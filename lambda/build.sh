#!/bin/bash
set -e
cd "$(dirname "$0")"


# build preprocessor
rm -f preprocessor_router.zip
zip -j preprocessor_router.zip preprocessor_router.py


# build actionable
rm -f actionable.zip
zip -j actionable.zip actionable_handler.py


# build non-actionable
rm -f non_actionable.zip
zip -j non_actionable.zip non_actionable_handler.py


echo "Built preprocessor_router.zip, actionable.zip and non_actionable.zip"
```


Make executable: `chmod +x lambda/build.sh`


---