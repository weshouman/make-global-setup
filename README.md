
This repo illustrates how to organize complex global Makefile targets.

### Usage

1. Clone this repo into ~/.config/makefiles..

2. To auto load those files add the following to `~/.bashrc`

```bash
export MAKEFILES_HOME="$HOME/.config/makefiles"
if [ -d ${MAKEFILES_HOME}/public ]; then
# Include all .mk files in ${MAKEFILES_HOME}/public
export MAKEFILES="$(find ${MAKEFILES_HOME}/public -name '*.mk' -print0 | xargs -0 echo)"
fi
```

### Concept

The demo shows organizing global make targets into public and internal targets, while using bash functions to run more complex scripts.

- `~/.config/makefiles/public/*.mk` includes public targets like `install-jb` and `install-helm`

- `~/.config/makefiles/internal/*.mk` includes internal targets like `_install-tool` and `_install-archived-tool`

It may be desired to have sub-directories under `public` to present multiple namespaces. Which should be auto populated as a public target

### Recommendation

This setup is fairly complex, Thus I recommend:

- Using global make targets only when the targets are not desired to be associated with a single project is desired.
- Using simple targets as much as possible
- Deferring as much logic to scripts
- Resorting to public/internal split only when reusability between different makefiles is desired which could be a complex scenario enough for such split.

**Personal usage recommendations**:
- Defining global targets like a `make help` target that parses the comment written on the target line
- Defining scoped targets per project, notice that MAKEFILES defined globally would be used everywhere which is not always desired, so MAKEFILES management is desirable in such sitations. Which can be achieved through scripting.
- Before applying the scripts in your env I recommend reading [the MAKEFILES manpage](https://www.gnu.org/software/make/manual/html_node/MAKEFILES-Variable.html) first.

