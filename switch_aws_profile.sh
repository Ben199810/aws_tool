#!/bin/bash

# 執行此腳本請使用 source 指令

# 字體顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

accounts_list=($(aws configure list-profiles))

current_account=$(env | grep AWS_PROFILE | cut -d'=' -f2)

PS3="Select AWS Account: "
select selected_account in "${accounts_list[@]}"; do
    case $selected_account in
      *)
        if [[ -n "$selected_account" && "$selected_account" == "$current_account" ]]; then
          echo -e "${YELLOW}Already using this account.${NC}"
          echo -e "${BLUE}Logout and login again to switch account.${NC}"
          unset AWS_PROFILE
          export AWS_PROFILE=${selected_account}
          echo -e "${GREEN}Switched to AWS profile: $AWS_PROFILE${NC}"
        elif [ -n "$selected_account" ]; then
          echo -e "${BLUE}Selected AWS Account: $selected_account${NC}"
          export AWS_PROFILE=${selected_account}
          echo -e "${GREEN}Switched to AWS profile: $AWS_PROFILE${NC}"
          aws sts get-caller-identity --no-cli-pager
        else
          echo -e "${RED}Invalid selection.${NC}"
        fi
        break
        ;;
    esac
done
