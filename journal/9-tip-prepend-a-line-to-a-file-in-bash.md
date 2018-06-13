# Tip: prepend a line to a file in bash

Easy way to prepend a line to a file using `sed`

``` bash
sed -i '1s|^|line to prepend|' /path/to/file
```

For instance:

``` bash
sed -i '1s|^|#!/usr/bin/env ruby\n|' /usr/local/bin/gem
```

This modifies the file in place, so no need for temp files.
