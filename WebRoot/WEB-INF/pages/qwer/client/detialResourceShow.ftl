<!DOCTYPE html>
<html>
<head>
	<base href="${CONTEXT_PATH}/"/>
    <meta name="viewport" content="width=device-width" />
    <link rel="stylesheet" href="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.css">
    <script src="plugin/jQuery/jquery-1.11.0.min.js"></script>
    <script src="plugin/jquery.mobile-1.4.2/jquery.mobile-1.4.2.min.js"></script>
</head>
<body>

<div data-role="page">
    <div data-role="header">
        <h1>${detialResourceShow.key_word}</h1>
    </div>

    <div data-role="content">
       ${detialResourceShow.content}
        <a href="javascript:history.go(-1);">返回</a>
    </div>


</div>

</body>
</html>