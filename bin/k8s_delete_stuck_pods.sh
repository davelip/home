#!/bin/bash
# delete-stuck-pods.sh
# Elimina pod in stato Pending o ContainerCreating
# Versione streaming: adatta a cluster grandi senza caricare JSON enorme

set -euo pipefail

# --- Default values ---
NAMESPACE=""
DRY_RUN=false
NAME_LIKE=""
OLDER_THAN_MIN=0

# --- Help function ---
usage() {
  echo "Uso: $0 [--namespace <nome>] [--name-like <pattern>] [--older-than <minuti>] [--dry-run]"
  echo
  echo "  --namespace, -n     Limita la ricerca a un namespace specifico"
  echo "  --name-like, -l     Filtro sul nome del pod (regex compatibile con grep -E)"
  echo "  --older-than, -t    Considera solo pod più vecchi di N minuti"
  echo "  --dry-run           Mostra solo i pod da eliminare, senza eseguire cancellazioni"
  echo "  --help, -h          Mostra questo messaggio"
  exit 0
}

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace|-n)
      NAMESPACE="$2"; shift 2;;
    --name-like|-l)
      NAME_LIKE="$2"; shift 2;;
    --older-than|-t)
      OLDER_THAN_MIN="$2"; shift 2;;
    --dry-run)
      DRY_RUN=true; shift;;
    --help|-h)
      usage;;
    *)
      echo "❌ Opzione sconosciuta: $1"
      usage;;
  esac
done

# --- Namespace selection ---
if [ -n "$NAMESPACE" ]; then
  NS_ARG="-n $NAMESPACE"
  echo "🎯 Namespace selezionato: $NAMESPACE"
else
  NS_ARG="--all-namespaces"
  echo "🌍 Nessun namespace specificato, controllo tutti."
fi

echo "🔍 Cercando pod in stato Pending o ContainerCreating..."

# --- cutoff timestamp per older-than ---
if [ "$OLDER_THAN_MIN" -gt 0 ]; then
  CUTOFF=$(date -u -d "-${OLDER_THAN_MIN} minutes" +%s)
else
  CUTOFF=0
fi

# --- raccolta pod streaming ---
pods_to_delete=()

while read -r ns pod status ctime; do
  # Filtro namespace (già gestito da kubectl)
  
  # Filtro name-like
  if [ -n "$NAME_LIKE" ] && ! echo "$pod" | grep -E -q "$NAME_LIKE"; then
    continue
  fi

  # Filtro older-than
  if [ "$OLDER_THAN_MIN" -gt 0 ] && [ -n "$ctime" ]; then
    pod_time=$(date -u -d "$ctime" +%s 2>/dev/null || echo 0)
    (( pod_time >= CUTOFF )) && continue
  fi

  pods_to_delete+=("$ns $pod")
done < <(
  # --- streaming pods ---
  kubectl get pods $NS_ARG -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,STATUS:.status.phase,CREATED:.metadata.creationTimestamp --no-headers | \
  awk '{print $1, $2, $3, $4}' | \
  while read ns pod phase ctime; do
    # Consideriamo Pending
    if [ "$phase" = "Pending" ]; then
      echo "$ns $pod $phase $ctime"
      continue
    fi
    # Controlliamo se c'è almeno un container in ContainerCreating
    cc=$(kubectl get pod "$pod" -n "$ns" -o jsonpath='{.status.containerStatuses[*].state.waiting.reason}' 2>/dev/null)
    if echo "$cc" | grep -q ContainerCreating; then
      echo "$ns $pod ContainerCreating $ctime"
    fi
  done
)

# --- Se non ci sono pod ---
if [ ${#pods_to_delete[@]} -eq 0 ]; then
  echo "✅ Nessun pod in stato Pending o ContainerCreating corrispondente ai criteri."
  exit 0
fi

# --- Mostra pod trovati ---
echo ""
echo "🧾 Pod trovati:"
for p in "${pods_to_delete[@]}"; do
  ns=$(echo $p | awk '{print $1}')
  pod=$(echo $p | awk '{print $2}')
  echo "- $ns/$pod"
done
echo ""

# --- Dry-run ---
if [ "$DRY_RUN" = true ]; then
  echo "💡 Modalità dry-run attiva: nessun pod sarà eliminato."
  exit 0
fi

read -p "⚠️ Vuoi procedere con l'eliminazione? (y/N) " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "❌ Operazione annullata."
  exit 0
fi

# --- Eliminazione pod ---
echo ""
echo "🚀 Eliminazione pod bloccati..."
for p in "${pods_to_delete[@]}"; do
  ns=$(echo $p | awk '{print $1}')
  pod=$(echo $p | awk '{print $2}')
  echo "🗑️  Eliminazione $pod (namespace: $ns)..."
  kubectl delete pod "$pod" -n "$ns" --grace-period=0 --force >/dev/null 2>&1 || \
    echo "⚠️  Errore eliminando $pod nel namespace $ns"
done

echo "✅ Tutti i pod selezionati sono stati eliminati."
