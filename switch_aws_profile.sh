#!/bin/bash

# 字體顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

accounts_list=($(aws configure list-profiles))

current_account=$(env | grep AWS_PROFILE | cut -d'=' -f2)

echo -e "${BLUE}Current AWS Profile: $current_account${NC}"

PS3="Select AWS Account: "
select selected_account in "${accounts_list[@]}"; do
    case $selected_account in
      *)
        if [[ -n "$selected_account" && "$selected_account" == "$current_account" ]]; then
          echo -e "${YELLOW}Already using this account.${NC}"
        elif [ -n "$selected_account" ]; then
          export AWS_PROFILE=${selected_account}
          echo -e "${BLUE}Selected AWS Account: $selected_account${NC}"
          echo -e "${GREEN}Switched to AWS profile: $AWS_PROFILE${NC}"
          aws sts get-caller-identity --no-cli-pager
        else
          echo -e "${RED}Invalid selection.${NC}"
        fi
        break
        ;;
    esac
done