THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
THIS_DIR      := $(dir $(THIS_MAKEFILE))
INST:="${THIS_DIR}/../internal/_install_tool.mk"

# Or we could use the absolute if MAKEFILES_HOME is defined
#INST:="${MAKEFILES_HOME}/internal/_install_tool.mk"

define install_with_env
	TOOL_NAME=$(TOOL_NAME) \
	TOOL_VERSION=$(TOOL_VERSION) \
	TOOL_URL=$(TOOL_URL) \
	$(MAKE) -f $(1) $(2)
endef

# Cryptic method
.PHONY: install-jb
# Notice that we resort to evaluation first because TOOL_VERSION needs 
install-jb:
	$(eval TOOL_NAME := jb)
	$(eval DEFAULT_VERSION := 0.5.1)
	$(eval TOOL_VERSION := $(if $(TOOL_VERSION),$(TOOL_VERSION),$(DEFAULT_VERSION)))
	$(eval TOOL_URL := https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v$(TOOL_VERSION)/jb-linux-amd64)
	$(call install_with_env,$(INST),_install-tool)

# Semi dynamic method
.PHONY: install-k9s
install-k9s:
	$(eval TOOL_NAME := k9s)
	$(eval DEFAULT_VERSION := 0.32.4)
	$(eval TOOL_VERSION := $(if $(TOOL_VERSION),$(TOOL_VERSION),$(DEFAULT_VERSION)))
	$(MAKE) -f $(INST) _install-archived-tool \
	TOOL_NAME=$(TOOL_NAME) \
	TOOL_VERSION=$(TOOL_VERSION) \
	TOOL_URL=https://github.com/derailed/k9s/releases/download/v$(TOOL_VERSION)/k9s_Linux_amd64.tar.gz

# Easy to read method, notice that making TOOL_VERSION dynamic requires usage of eval
.PHONY: install-helm
DEFAULT_HELM_VERSION := 3.14.3
install-helm:
	$(eval TOOL_VERSION := $(if $(TOOL_VERSION),$(TOOL_VERSION),$(DEFAULT_HELM_VERSION)))
	@$(MAKE) -f $(INST) _install-archived-tool \
	TOOL_NAME=helm \
	TOOL_VERSION=$(TOOL_VERSION) \
	TOOL_BIN=/usr/local/bin/helm \
	TOOL_TMP=/tmp/helm-$(TOOL_VERSION) \
	TOOL_URL=https://get.helm.sh/helm-v$(TOOL_VERSION)-linux-amd64.tar.gz
