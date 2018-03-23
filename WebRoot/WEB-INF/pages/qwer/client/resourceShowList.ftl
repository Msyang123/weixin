<!DOCTYPE html>
<html>
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta name="viewport" content="width=device-width" />
    <link rel="stylesheet" href="${CONTEXT_PATH}plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.css">

    <script src="${CONTEXT_PATH}plugin/jQuery/jquery-1.11.0.min.js"></script>
    <script src="${CONTEXT_PATH}plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.js"></script>
</head>
<body>

<div data-role="page">
    <div data-role="header">
        <h1>便民服务</h1>
    </div>

    <div data-role="content">
        <ul data-role="listview">
            <#list resourceShowList as item>
                <li>
                    <#if item.content??>
                        <a href="detialResourceShow?id=${item.id}">
                            <h2>${item.key_word}</h2>
                        </a>
                    <#else>
                        <a href="${item.url}">
                            <h2>${item.key_word}</h2>
                        </a>
                    </#if>
                </li>
            </#list>
        </ul>
    </div>


</div>

</body>
</html>