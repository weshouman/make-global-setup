.PHONY: _install-tool

TOOL_BIN = /usr/local/bin/$(TOOL_NAME)
TOOL_TMP = /tmp/$(TOOL_NAME)-$(TOOL_VERSION)

# Original Code, not easy to maintain yet clearly colcated
# _install-tool_embedded_script:
# 	@echo "Attempting to download $(TOOL_NAME) version $(TOOL_VERSION)..."
# 	@status=$$(curl -L -w "%{http_code}" -o $(TOOL_TMP) "$(TOOL_URL)" -s -S); \
# 	if [ "$$status" -ne 200 ]; then \
# 		echo "\033[1;31mError downloading $(TOOL_NAME): Version $(TOOL_VERSION) not found or download failed.\033[0m"; \
# 		echo "Status code: $$status"; \
# 		echo "URL: $(TOOL_URL)"; \
# 		rm $(TOOL_TMP); \
# 		exit 1; \
# 	else \
# 		echo "Download succeeded."; \
# 		chmod +x $(TOOL_TMP); \
# 		sudo mv $(TOOL_TMP) $(TOOL_BIN); \
# 		echo "\033[1;32m$(TOOL_NAME) installed successfully to $(TOOL_BIN).\033[0m"; \
# 	fi

_install-tool:
	@bash $(dir $(lastword $(MAKEFILE_LIST)))/install_bin.sh --mode direct \
	--name "$(TOOL_NAME)" \
	--version "$(TOOL_VERSION)" \
	--tmp "$(TOOL_TMP)" \
	--url "$(TOOL_URL)" \
	--bin "$(TOOL_BIN)"

_install-archived-tool:
	bash $(dir $(lastword $(MAKEFILE_LIST)))/install_bin.sh --mode archived \
	--name "$(TOOL_NAME)" \
	--version "$(TOOL_VERSION)" \
	--tmp "$(TOOL_TMP)" \
	--url "$(TOOL_URL)" \
	--bin "$(TOOL_BIN)"
