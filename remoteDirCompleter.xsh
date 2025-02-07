def remoteDirCompleter(prefix, line, begindx, endidx, ctx):
    import re

    hostPathRegex = "[\"\']?[A-Za-z]+:[^:]*"
    results = re.findall("^" + hostPathRegex + "$", prefix)

    if results: # is not empty

        result = results[0]


        if result.startswith("\"") or result.startswith("\'"):
            result = result[1:-1]

        hostName, path = result.split(":")

        # Get matching files
        fileList = re.split("\n", $(ssh @(hostName) ls -d1F --file-type @(path + "*")))

        # Remove empty entries
        fileList = filter(lambda x: x != '', fileList)

        # Escape control characters
        # fileList = map(lambda x: x.replace("&", "\\&"), fileList)
        # fileList = map(lambda x: x.replace("'", "\\'"), fileList)
        # fileList = map(lambda x: x.replace("\"", "\\\""), fileList)
        # fileList = map(lambda x: x.replace(" ", "\\ "), fileList)

        # Prefixes the suggestions with the host name
        fileList = map(lambda x: hostName + ":" + x, fileList)

        # Wrap paths in quotes
        fileList = map(lambda x: "'" + x + "'", fileList)

        return set(fileList)

    return None