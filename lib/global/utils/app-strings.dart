class AppStrings{
    static const String keyLogged = "isLogged";
    static const String keyFirstLogin = "firstLogin";
    static const String keyUserName = "userName";
    static const String keyFirstAccess = "firstAccess";
    static const String keyHolder = "isHolder";
    static const String keyUid = "uid";
    static const String keyFullRegistration = "fullRegistration";
    static const String keyConexaId = "conexaId";

    static const String collectionDocuments = "documents";
    static const String collectionUsers = "users";
    static const String collectionHolders = "holders";
    static const String collectionDependents = "dependents";
    static const String collectionAuthUsers = "auth_users";
    static const String collectionAttendance = "attendance";
    static const String collectionSchedule = "schedule";
    static const String collectionScreens = "screens";

    static const String documentAttendanceActive = "active";
    static const String documentAttendanceCanceled = "canceled";
    static const String documentAttendanceFinished = "finished";
    static const String documentAttendanceInactive = "inactive";

    static const String oneSignalAppId = "94558797-4695-45b0-8fcd-67d413270ee3";
    static const String oneSignalRestApiKey = "MmNkMjZmOWUtNmJhMi00ZGI0LWFiOTctMzExMzYzNzc3ZmEy";

    static const String vindiBaseUrl = 'https://app.vindi.com.br/api/v1';
    static const String vindiAuthorization = 'Basic WUo5U1BoLXVyakZzVGc5TjE2T3Y5V2cwNUJjNTFvbkNIWDMxWDFUWFNhWTp1bmRlZmluZWQ=';
    static const String vindiAccept = 'application/json';

    static const String conexaBaseUrl = 'https://api.conexasaude.com.br/integration/enterprise'; //TODO: url em prod
    // static const String conexaBaseUrl = 'https://hml-api.conexasaude.com.br/integration/enterprise'; //TODO: url em homol
    static const String conexaToken = '32048224abe425a5cd46db20b1b5d6a4'; //TODO: chave em prod
    // static const String conexaToken = 'a848d0138c9141811938170eb8dd153c'; //TODO: chave em homol
    static const String conexaContentType = 'application/json';

    static String initSalutation() {
        var hour = DateTime.now().hour;
        if (hour < 12) {
            return '*Bom dia!*';
        }
        if (hour < 18) {
            return '*Boa tarde!*';
        }
        return '*Boa noite!*';
    }
}