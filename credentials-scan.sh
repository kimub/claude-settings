#!/opt/homebrew/bin/bash

# 색상 정의
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 디렉토리 설정
SCAN_DIR="${1:-.}"
PARALLEL_JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

if [ ! -d "$SCAN_DIR" ]; then
    printf "${RED}오류: 디렉토리 $SCAN_DIR 가 존재하지 않습니다${NC}\n"
    exit 1
fi

printf "${GREEN}보안 스캔 시작: $SCAN_DIR (병렬작업: ${PARALLEL_JOBS}개)${NC}\n\n"

# 결과 카운터
TOTAL_FINDINGS=0

# 임시 파일들
TEMP_RESULTS=$(mktemp)
TEMP_FILE_LIST=$(mktemp)

# 검사 패턴 정의 (영문 키 사용)
declare -A PATTERNS=(
    # AWS
    ["aws_access_key"]="(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}"
    ["aws_secret_key"]="aws(.{0,20})?['\"][0-9a-zA-Z/+]{40}['\"]"
    ["aws_account_id"]="aws(.{0,20})?['\"][0-9]{12}['\"]"
    
    # Azure
    ["azure_storage_key"]="DefaultEndpointsProtocol=https;AccountName=.{1,100};AccountKey=[A-Za-z0-9+/=]{88}"
    ["azure_connection_string"]="DefaultEndpointsProtocol=https;AccountName=[^;]+;AccountKey=[A-Za-z0-9+/=]{88};EndpointSuffix="
    ["azure_client_secret"]="(client[_-]?secret|AZURE[_-]?CLIENT[_-]?SECRET|ClientSecret)(.{0,20})?[=:]['\"]?[0-9a-zA-Z~._-]{34,40}['\"]?"
    
    # GCP
    ["gcp_api_key"]="AIza[0-9A-Za-z_-]{35}"
    ["gcp_service_account"]="\"type\": \"service_account\""
    
    # GitHub
    ["github_pat"]="ghp_[A-Za-z0-9]{36}"
    ["github_fine_grained_pat"]="github_pat_[A-Za-z0-9_]{82}"
    
    # GitLab
    ["gitlab_pat"]="glpat-[A-Za-z0-9_-]{20,}"
    
    # SSH Keys
    ["ssh_private_key"]="-----BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY-----"
    
    # Generic Secrets
    ["generic_api_key"]="(api[_-]?key|apikey)(.{0,20})?[=:]['\"]?[0-9a-zA-Z_-]{20,}['\"]?"
    ["generic_secret_key"]="(secret[_-]?key|secretkey)(.{0,20})?[=:]['\"]?[0-9a-zA-Z_-]{20,}['\"]?"
    ["generic_access_token"]="(access[_-]?token|accesstoken)(.{0,20})?[=:]['\"]?[0-9a-zA-Z_-]{20,}['\"]?"
    
    # Database
    ["mongodb_connection"]="mongodb(\+srv)?://[^:]+:[^@]+@"
    ["mysql_connection"]="mysql://[^:]+:[^@]+@"
    ["postgresql_connection"]="postgres(ql)?://[^:]+:[^@]+@"
    ["redis_connection"]="redis://[^:]*:[^@]+@"
    
    # Private Keys & Certificates
    ["private_certificate"]="-----BEGIN PRIVATE KEY-----"
    ["rsa_private_key"]="-----BEGIN RSA PRIVATE KEY-----"
    
    # JWT
    ["jwt_token"]="eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_.-]{10,}"
    
    # Slack
    ["slack_token"]="xox[baprs]-[0-9]{10,13}-[0-9]{10,13}-[A-Za-z0-9]+"
    ["slack_webhook"]="https://hooks\.slack\.com/services/T[A-Z0-9]{8}/B[A-Z0-9]{8}/[A-Za-z0-9]{24}"
    
    # Docker
    ["docker_hub_token"]="dckr_pat_[A-Za-z0-9_-]{32,}"
    
    # NPM
    ["npm_token"]="npm_[A-Za-z0-9]{36}"
    
    # Grafana
    ["grafana_api_key"]="eyJrIjoi[A-Za-z0-9_-]{32,}"
    ["grafana_service_account"]="glsa_[A-Za-z0-9]{32}_[a-f0-9]{8}"
    
    # ArgoCD
    ["argocd_auth_token"]="argocd\.token[=:]['\"]?[A-Za-z0-9_-]{20,}['\"]?"
    ["argocd_admin_secret"]="argocd-initial-admin-secret"
    
    # Prometheus
    ["prometheus_bearer_token"]="bearer_token:\s*['\"]?[A-Za-z0-9_-]{20,}['\"]?"
    
    # Loki
    ["loki_bearer_token"]="loki.*bearer_token:\s*['\"]?[A-Za-z0-9_-]{20,}['\"]?"
    
    # OpenTelemetry
    ["otlp_api_key"]="(otlp|otel)[_-]?(api[_-]?key|token)[=:]['\"]?[A-Za-z0-9_-]{20,}['\"]?"
)

# 패턴 이름을 한글로 매핑
declare -A PATTERN_NAMES=(
    ["aws_access_key"]="AWS 액세스 키"
    ["aws_secret_key"]="AWS 시크릿 키"
    ["aws_account_id"]="AWS 계정 ID"
    ["azure_storage_key"]="Azure 스토리지 키"
    ["azure_connection_string"]="Azure 연결 문자열"
    ["azure_client_secret"]="Azure 클라이언트 시크릿"
    ["gcp_api_key"]="GCP API 키"
    ["gcp_service_account"]="GCP 서비스 계정"
    ["github_pat"]="GitHub 개인 액세스 토큰"
    ["github_fine_grained_pat"]="GitHub Fine-grained PAT"
    ["gitlab_pat"]="GitLab 개인 액세스 토큰"
    ["ssh_private_key"]="SSH 개인 키"
    ["generic_api_key"]="일반 API 키"
    ["generic_secret_key"]="일반 시크릿 키"
    ["generic_access_token"]="일반 액세스 토큰"
    ["mongodb_connection"]="MongoDB 연결 문자열"
    ["mysql_connection"]="MySQL 연결 문자열"
    ["postgresql_connection"]="PostgreSQL 연결 문자열"
    ["redis_connection"]="Redis 연결 문자열"
    ["private_certificate"]="개인 인증서"
    ["rsa_private_key"]="RSA 개인 키"
    ["jwt_token"]="JWT 토큰"
    ["slack_token"]="Slack 토큰"
    ["slack_webhook"]="Slack 웹훅"
    ["docker_hub_token"]="Docker Hub 토큰"
    ["npm_token"]="NPM 토큰"
    ["grafana_api_key"]="Grafana API 키"
    ["grafana_service_account"]="Grafana 서비스 계정 토큰"
    ["argocd_auth_token"]="ArgoCD 인증 토큰"
    ["argocd_admin_secret"]="ArgoCD 서버 패스워드"
    ["prometheus_bearer_token"]="Prometheus Bearer 토큰"
    ["loki_bearer_token"]="Loki Bearer 토큰"
    ["otlp_api_key"]="OTLP API 키"
)

# 제외할 디렉토리
EXCLUDE_DIRS=".git node_modules vendor .terraform __pycache__ dist build .next .nuxt coverage"

# 패턴을 하나의 큰 정규표현식으로 합치기
COMBINED_PATTERN=""
for pattern in "${PATTERNS[@]}"; do
    if [ -z "$COMBINED_PATTERN" ]; then
        COMBINED_PATTERN="($pattern)"
    else
        COMBINED_PATTERN="$COMBINED_PATTERN|($pattern)"
    fi
done

# 스캔할 파일 목록 먼저 생성
printf "${YELLOW}파일 목록 생성 중...${NC}\n"
find_cmd="find \"$SCAN_DIR\" -type f"
for dir in $EXCLUDE_DIRS; do
    find_cmd="$find_cmd -not -path \"*/$dir/*\""
done

eval $find_cmd | while read -r file; do
    if file "$file" 2>/dev/null | grep -q "text"; then
        echo "$file"
    fi
done > "$TEMP_FILE_LIST"

TOTAL_FILES=$(wc -l < "$TEMP_FILE_LIST")
printf "${GREEN}검사할 파일 수: ${TOTAL_FILES}개${NC}\n\n"

# 개별 파일 스캔 함수
scan_single_file() {
    local file="$1"
    local combined_pattern="$2"
    local temp_output=$(mktemp)
    
    if grep -qEi "$combined_pattern" "$file" 2>/dev/null; then
        echo "$file" >> "$temp_output"
    fi
    
    cat "$temp_output"
    rm -f "$temp_output"
}

export -f scan_single_file
export COMBINED_PATTERN

# 병렬 처리로 파일 스캔
printf "${YELLOW}보안 크리덴셜 스캔 중...${NC}\n\n"

MATCHED_FILES=$(mktemp)

if command -v parallel &> /dev/null; then
    cat "$TEMP_FILE_LIST" | parallel -j "$PARALLEL_JOBS" --bar scan_single_file {} "$COMBINED_PATTERN" > "$MATCHED_FILES" 2>/dev/null
elif command -v xargs &> /dev/null; then
    cat "$TEMP_FILE_LIST" | xargs -P "$PARALLEL_JOBS" -I {} bash -c 'scan_single_file "$@"' _ {} "$COMBINED_PATTERN" > "$MATCHED_FILES"
else
    while read -r file; do
        scan_single_file "$file" "$COMBINED_PATTERN"
    done < "$TEMP_FILE_LIST" > "$MATCHED_FILES"
fi

# 매칭된 파일들에 대해서만 상세 분석
if [ -s "$MATCHED_FILES" ]; then
    printf "\n${YELLOW}매칭된 파일 상세 분석 중...${NC}\n\n"
    
    while read -r file; do
        for pattern_key in "${!PATTERNS[@]}"; do
            pattern="${PATTERNS[$pattern_key]}"
            pattern_name="${PATTERN_NAMES[$pattern_key]}"
            matches=$(grep -nEi "$pattern" "$file" 2>/dev/null || true)
            
            if [ -n "$matches" ]; then
                printf "${RED}[발견] $pattern_name${NC}\n" >> "$TEMP_RESULTS"
                printf "  ${BLUE}파일: ${YELLOW}$file${NC}\n" >> "$TEMP_RESULTS"
                echo "$matches" | head -3 | while IFS=: read -r line_num line_content; do
                    printf "  ${GREEN}라인 $line_num:${NC} ${line_content:0:150}\n" >> "$TEMP_RESULTS"
                done
                if [ $(echo "$matches" | wc -l) -gt 3 ]; then
                    printf "  ${YELLOW}... 그 외 $(( $(echo "$matches" | wc -l) - 3 ))개 더 발견${NC}\n" >> "$TEMP_RESULTS"
                fi
                echo "" >> "$TEMP_RESULTS"
                ((TOTAL_FINDINGS++))
            fi
        done
    done < "$MATCHED_FILES"
fi

# 결과 출력
printf "\n${GREEN}==================== 스캔 결과 ====================${NC}\n\n"

if [ $TOTAL_FINDINGS -eq 0 ]; then
    printf "${GREEN}✓ 보안 크리덴셜이 발견되지 않았습니다!${NC}\n"
    printf "${GREEN}✓ 코드가 안전한 것으로 보입니다.${NC}\n"
else
    cat "$TEMP_RESULTS"
    printf "${RED}==================== 요약 ====================${NC}\n"
    printf "${RED}총 발견 항목: $TOTAL_FINDINGS개${NC}\n"
    printf "${YELLOW}⚠️  하드코딩된 크리덴셜을 검토하고 제거해주세요!${NC}\n"
    printf "${YELLOW}⚠️  환경 변수 또는 시크릿 관리 도구 사용을 권장합니다.${NC}\n"
fi

# 임시 파일 삭제
rm -f "$TEMP_RESULTS" "$TEMP_FILE_LIST" "$MATCHED_FILES"

printf "\n${BLUE}검사 완료 (총 ${TOTAL_FILES}개 파일, ${#PATTERNS[@]}개 패턴 검사)${NC}\n"

exit $TOTAL_FINDINGS
