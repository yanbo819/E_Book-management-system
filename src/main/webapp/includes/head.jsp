<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="_lang" value="${empty sessionScope.lang ? 'en' : sessionScope.lang}" />
<fmt:setLocale value="${_lang}" scope="session"/>
<!DOCTYPE html>
<html lang="${_lang}" dir="${_lang eq 'ar' ? 'rtl' : 'ltr'}">
<head>
    <fmt:bundle basename="messages">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><fmt:message key="app.title"/></title>
        <meta name="description" content="<fmt:message key='app.description'/>"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/theme-ai.js" defer></script>
    </fmt:bundle>
</head>
<body>