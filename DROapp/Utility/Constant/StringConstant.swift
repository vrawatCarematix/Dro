//
//  StringConstant.swift
//  blip
//
//  Created by Carematix on 25/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
enum Collapse{
    case  open
    case  close
}

enum DashboardCellType{
    case  DueToday
    case  Upcoming
    case  Timeline
    case  Statistics
}

let kExpandDuration = 0.09

let kOpen = "Open"
let kCell = "DashBoardCell"
let kTerms = "https://wellness.blipcare.com/portal/f?p=100:4060"
let kPrivacy = "https://wellness.blipcare.com/portal/f?p=100:4065"
let kBuyDevice = "https://www.blipcare.com"

let kUserDefault = UserDefaults.standard

let kAlreadyHaveAccount = "AlreadyHaveAccount"
let kSignUp = "SIGNUP"
let kAuthKey = "authKey"
let kLoggedIn = "loggedIn"
let kFirstTimeApp = "FirstTimeApp"
let kAppCurrentVersion = "AppCurrentVersion"

let kYes = "yes"
let kNo = "no"
let kLastSyncTime = "lastSyncTime"
let kCurrentUserId = "CurrentUserId"
let kReloadAllData = "ReloadAllData"
let kReloadDateController = "ReloadDateController"

let kReloadSettingData = "ReloadSettingData"
let kDemo = "Demo"
let kReal = "Real"

let kUserType = "UserType"
let kTermsCondition = "Terms"
let kPrivcay = "Privacy"

let kWeight = "Weight"
let kKg = "Kg"
let kPound = "Pounds"
let kSelectPerson = "SelectPerson"
let kInches = "Inches"
let kCm = "Cm"
let kStartDate = "StartDate"
let kSelectedMonth = "selectedMonth"

let kImage = "image"
let kText = "text"
let kVideo = "video"
let kAudio = "audio"
let kuserName = "userName"
let kRootScreen = "RootScreen"
let kLastDashboardRefresh = "LastDashboardRefresh"
let kLastProfileRefresh = "LastProfileRefresh"
let kLastMessageRefresh = "LastMessageRefresh"

let kfirstName = "firstName"
let klastName = "lastName"
let kuserImage = "kuserImage"
let klastVisitedDate = "lastVisitedDate"
let klogoURL = "logoURL"
let korganizationName = "organizationName"
let kprogramId = "programId"
let kprogramName = "programName"
let kfromDate = "fromDate"
let ktoDate = "toDate"
let kassigned = "assigned"
let kcompleted = "completed"
let kactive = "active"
let kdeclined = "declined"
let kexpired = "expired"
let kProfileData = "ProfileData"
let kProgramUserId  = "programUserId"
let kProflieImage = "ProflieImage"

let kUserId  = "userId"
let kOldCompleteCount  = "OldCompleteCount"
let kOldExpiredCount  = "OldExpiredCount"
let kOldDeclineCount  = "OldDeclineCount"
let kOldAssignCount  = "OldAssignCount"

let kIOS  = "IOS"

let kaveragePerWeek = "averagePerWeek"
let kReloadUserData = "ReloadUserData"
let kNetworkAvailable = "NetworkAvailable"

let kLastDashboardUpdate = "lastDashboardUpdate"
let kLastRefreshTime = "lastRefreshTime"

let kReloadViewDroData = "ReloadViewDroData"
let kReloadMessageData = "ReloadMessageData"

let kDroSort = "DroSort"
let kDroStatus = "DroStatus"
let kMessageStatus = "MessageStatus"
let kMessageSort = "MessageSort"
let kDroAsc = "DroAsc"
let kDroDsc = "DroDsc"
let kSortStatus = "SortStatus"

let kDivHeader = "DIV_HEADER"
let kDivBody = "DIV_BODY"

let kDIV_HEADER_BODY = "DIV_HEADER_BODY"

let kPrivacyPolicy = "PRIVACY_POLICY"
let pDisclaimer = "DISCLAIMER"
let kTerm_Condition = "TERM_CONDITION"
let kSTUDY_INFO = "STUDY_INFO"
let kPersonalDetails = "PERSONAL_DETAILS"

let kLegalStatement = "LEGAL_STATEMENT"
let kDivSubheader = "DIV_SUBHEADER"

let kSFLight = "SFProDisplay-Light"

let kSFRegular = "SFProDisplay-Regular"
let kSFSemibold = "SFProDisplay-Semibold"

let kComponentTextBox = "TEXT_BOX"
let kComponentRadioButton = "RADIO_BUTTON"
let kComponentNumeric = "NUMERIC"
let kComponentDropDown = "DROP_DOWN"
let kComponentDate = "DATE"
let kComponentCheckBox = "CHECK_BOX"



let kwelcome = "welcome"
let kchange_password = "change_password"
let kdashboard = "dashboard"
let kdecline_confirmation = "decline_confirmation"
let kfooter = "footer"
let kheader = "header"
let klegal_statement = "legal_statement"
let klogin = "login"
let kmisc = "misc"
let kpersonal_details = "personal_details"
let kprivacy_policy = "privacy_policy"
let ksurvey_detail = "survey_detail"
let ksurvey_intent = "survey_intent"
let ksurvey_schedule = "survey_schedule"
let kterms_and_conditions = "terms_and_conditions"
let kview_dro = "view_dro"
let kview_message = "view_message"
let kselectedLanguage = "selectedLanguage"

let klanguagechange = "languagechange"
let klanguageDictionary = "languageDictionary"
let kDefaultEnglishDictionary = "DefaultEnglishDictionary"

let kASSIGNED = "ASSIGNED"
let kDECLINED = "DECLINED"

let kCOMPLETED = "COMPLETED"
let kTERMINATED = "TERMINATED"
let kUPCOMING = "UPCOMING"
let kEXPIRED = "EXPIRED"
let kSTARTED = "STARTED"
let kNOT_STARTED = "NOT_STARTED"
let KCONTINUE = "CONTINUE"

let kDashboardCollapse = "DashboardCollapse"

//Parameter
 let pusername = "userName"
 let ppassword = "password"
 let planguage = "language"
 let psource = "source"
 let pX_DRO_TOKEN = "X-DRO-TOKEN"
 let pprogramInfo = "programInfo"
let pCDMCss = "CDMCss"
//WelcomeScreen

let kWelcome = "Welcome"
let kWelcome_Description = "Welcome_Description"
let kEmail_SignIn  = "Email_SignIn"
let kMicrosoft_SignIn  = "Microsoft_SignIn"
let kCurrently_Not_Available  = "Currently_Not_Available"

//SingIN
let kForgot_Password = "Forgot_Password"
let kSign_In = "Sign_In"
let kEmail = "Email"
let kPassword = "Password"
let kAuthenticating = "Authenticating"



//Left View Controller
let kLanguage = "Language"
let kChange_Password = "Change_Password"
let kLogout = "Logout"
let kTerms_Conditions = "Terms_Conditions"
let kDisclaimer = "Disclaimer"
let kPrivacy_Policy = "Privacy_Policy"
let kLegal_Statement = "Legal_Statement"


//Study Information
let kStudy_Information = "Study_Information"
let kRead_More = "Read_More"
let kRead_Less = "Read_Less"

//Message
let kSearch = "Search"
let kMessages = "Messages"
let kNo_Message_Found = "No_Message_Found"

//Message Filter
let kSort_Filter = "Sort_Filter"
let kDate_Time_Asc = "Date_Time_Asc"
let kDate_Time_Desc = "Date_Time_Desc"
let kSender = "Sender"
let kStatus = "Status"
let kAll = "All"
let kRead = "Read"
let kUnread = "Unread"
let kStarred = "Starred"
let kApply = "Apply"
let kReset = "Reset"
let kSort_by = "Sort_by"
let kSender_Name = "Sender_Name"

// Detail Message
let kUpdating = "Updating"

// Tab Bar
let kSchedule =  "Schedule"
let kView_DROs = "View_DROs"
let kDashboard = "Dashboard"
let kStudy = "Study"

// Change Password

let kCurrent_Password = "Current_Password"
let kNew_Password = "New_Password"
let kConfirm_Password = "Confirm_Password"
let kConfirm = "Confirm"

//Success Change Password
let kSuccess = "Success"
let kPassword_Changed = "Password_Changed"
let kContinue_To_Login = "Continue_To_Login"

//Schedule Controller
let kStart = "Start"
let kContinue = "Continue"
let kDeclined = "Declined"
let kExpired = "Expired"
let kSchedule_DRO = "Schedule_DRO"
let kDRO_Scheduled_Today = "DRO_Scheduled_Today"
let kDue_by = "Due_by" 
let kStarts_at = "Starts_at"

//ViewDro
let kAssigned = "Assigned"
let kCompleted = "Completed"
let kActive = "Active"

//DASHBOARD
let kLast_Visit = "Last_Visit"

//Activity Indicator
let kRefreshing = "Refreshing"
let kLoading = "SyncingData"
let kSyncingData = "SyncingData"

//Alert
let kAlert = "Alert"
let kPassword_Error = "Password_Error"
let kError = "Error"

//ErrorMesssage
let kEmpty_Email = "Empty_Email"
let kInvalid_Email = "Invalid_Email"
let kEmpty_Password = "Empty_Password"
let kLogout_Message = "Logout_Message"
let kLogout_Offline_Message = "Logout_Offline_Message"
let kPassword_Mismatch = "Password_Mismatch"


//Edit Profile

let kEditProfile = "Edit_Profile"
let kEdit = "Edit"
let kDone = "Done"

// Profile

let kProfile = "Profile"


//Terms
let kLast_Updated = "Last_Updated"



let englishJson : [String : String] = [
    //WelcomeScreen
    "Welcome" : "Welcome",
    "Welcome_Description" : "We would like you to complete these questionaire about your condition. We would use these questionaires to help us understand your unique situatuion so that we can provide the type of care that will help you the most.",
    "Email_SignIn" : "Sign in Using Email",
    "Microsoft_SignIn" : "Sign in with Microsoft Live",
    "Currently_Not_Available" : "Currently not available",
    //SingIN
    "Forgot_Password" : "Forgot Password",
    "Sign_In" : "Sign in",
    "Email" : "Email",
    "Password" : "Password",
    "Authenticating" : "Authenticating",
    
    //Forgot
    "Email_Or_Mobile" : "Email or Mobile",
    "Forgot_Description" : "Just let us know your registered email address or mobile number",
    "Get_OTP" : "Get OTP",
    "Resend_OTP" : "Resend OTP",
    "Enter_OTP" : "Enter OTP",
    "Verify" : "Verify",
    "OTP_Description" : "Please enter 4-digit OTP sent via SMS to your registered mobile number",
    
    //Left View Controller
    "Language" : "Language",
    "Change_Password" : "Change Password",
    "Logout" : "Logout",
    "Terms_Conditions" : "Terms & Conditions",
    "Disclaimer" : "Disclaimer",
    "Privacy_Policy" : "Privacy Policy",
    "Legal_Statement" : "Legal Statement",
    
    
    //Study Information
    "Study_Information" : "Study Information",
    "Read_More" : "Read More",
    "Read_Less" : "Read Less",

    //Message
    "Search" : "Search",
    "Messages" : "Messages",
    "No_Message_Found" : "No message found.",
    
    //Message Filter
    "Sort_Filter" : "Sort & Filter",
    "Sort_by" : "Sort by",
    "Date_Time_Asc" : "Date & Time (Ascending)",
    "Date_Time_Desc" : "Date & Time (Descending)",
    "Sender" : "Sender",
    "Status" : "Status",
    "All" : "All",
    "Read" : "Read",
    "Unread" : "Unread",
    "Starred" : "Starred",
    "Apply" : "Apply",
    "Reset" : "Reset",
    "Sender_Name" : "Sender Name",
    
    // Detail Message
    "Updating" : "Updating",
    
    // Tab Bar
    "Schedule" : "Schedule",
    "View_DROs" : "View DROs",
    "Dashboard" : "Dashboard",
    "Study" : "Study",
    
    // Change Password
    "Current_Password" : "Current Password",
    "New_Password" : "New Password",
    "Confirm_Password" : "Confirm Password",
    "Confirm" : "Confirm",
    
    //Success Change Password
    "Success" : "Success",
    "Password_Changed" : "Password has been successfully changed",
    "Continue_To_Login" : "Continue To Login",
    
    //Schedule Controller
    "Start" : "Start",
    "Continue" : "Continue",
    "Declined" : "Declined",
    "Expired" : "Expired",
    "Schedule_DRO" : "Schedule DRO",
    "DRO_Scheduled_Today" : "You have kCOUNT DROs scheduled on kDATE",
    "Due_by" : "Due by",
    "Starts_at" : "Starts at",
    
    //ViewDro
    "Assigned" : "Assigned",
    "Completed" : "Completed",
    "Active" : "Active",

    //DASHBOARD
    "Last_Visit" : "Your last visit was on ",

    //Activity Indicator
    "Refreshing" : "Refreshing",
    "Loading" : "Loading",
    "SyncingData" : "Syncing Data",
    
    //Alert
    "Alert" : "Alert",
    "Password_Error" : "Password Error",
    "Error" : "Error",
    
    //ErrorMesssage
    "Empty_Email" : "Please enter email id",
    "Invalid_Email" : "Please enter valid email id",
    "Empty_Password" : "Please enter password",
    "Password_Mismatch" : "The Passwords do not match",
    "Logout_Message" : "Are you sure want to logout?",
    "Logout_Offline_Message" : "If you logout in offline mode , you will loose your unsync survey progress. \n \n Are you sure want to logout? ",
    //Edit Profile
    
    "Edit_Profile" : "Edit Profile",
    "Edit" : "Edit",
    "Done" : "Done",
    
    // Profile
    "Profile" : "Profile",

    //Terms
    "Last_Updated" : "Last Updated",
]

let spanishJson: [String: String] = [
    //Pantalla de bienvenida
    
    "Welcome" :  "Bienvenido",
    
    "Welcome_Description": "Nos gustaría que completara estos cuestionarios sobre su condición. Usaremos estos cuestionarios para ayudarnos a comprender su situación única a fin de poder brindarle el tipo de atención que más le ayude",
    
    "Email_SignIn": "Iniciar sesión usando correo electrónico",
    
    "Microsoft_SignIn": "Iniciar sesión con Microsoft Live",
    "Currently_Not_Available": "Actualmente no está disponible",
    // cantar
    "Forgot_Password": "Olvidé mi contraseña",
    "Sign_In": "Iniciar sesión",
    "Email": "Correo electrónico",
    "Password": "Contraseña",
    "Authenticating": "Autentificación",
    
    //Olvidó
    "Email_Or_Mobile": "Email o móvil",
    "Forgot_Description": "Simplemente háganos saber su dirección de correo electrónico registrada o número de teléfono móvil",
    "Get_OTP": "Get OTP",
    "Resend_OTP": "Reenviar OTP",
    "Enter_OTP": "Entrar en OTP",
    "Verificar": "Verificar",
    "OTP_Description": "Ingrese la OTP de 4 dígitos enviada por SMS a su número de teléfono móvil registrado",
    
    // Controlador de vista izquierda
    "Language" : "idioma",
    "Change_Password": "Cambiar contraseña",
    "Logout": "Cerrar sesión",
    "Terms_Conditions": "Términos y condiciones",
    "Disclaimer": "Descargo de responsabilidad",
    "Privacy_Policy": "Política De Privacidad",
    "Legal_Statement": "Declaración legal",
    
    
    // Información del estudio
    "Study_Information": "Información Del Estudio",
    "Read_More" : "Leer más",
    "Read_Less" : "Leer menos",

    //Mensaje
    "Search" :  "Buscar",
    "Messages": "Mensajes",
    "No_Message_Found": "No se encontró ningún mensaje.",
    
    // Filtro de mensajes
    "Sort_Filter": "Filtro de clasificación",
    "Sort_by": "Ordenar por",
    "Date_Time_Asc": "Fecha y hora (ascendente)",
    "Date_Time_Desc": "Fecha y hora (descendente)",
    "Sender": "Remitente",
    "Status": "Estado",
    "All": "TodAs",
    "Read" : "Leer",
    "Unread" : "No leído",
    "Starred" : "Sembrado de estrellas",
    "Apply": "Aplicar",
    "Reset": "Restablecer",
    "Sender_Name": "Nombre del remitente",
    
    // Mensaje de detalle
    "Updating": "Actualizando",
    
    // Barra de pestañas
    "Schedule": "Horario",
    "View_DROs": "Ver DROs",
    "Dashboard": "Tablero",
    "Study" : "Estudio",
    
    // Cambia la contraseña
    "Current_Password": "Contraseña actual",
    "New_Password": "Nueva contraseña",
    "Confirm_Password contraseña": "Confirmar contraseña",
    "Confirm": "Confirmar",
    
    // Contraseña de cambio de éxito
    "Success": "Éxito",
    "Password_Changed": "La contraseña se ha cambiado correctamente",
    "Continue_To_Login": "Continuar para iniciar sesión",
    
    // Controlador de horarios
    "Start": "Comienzo",
    "Continue": "Continuar",
    "Declined": "Rechazado",
    "Expired": "Muerto",
    "Schedule_DRO": "horario dro",
    "DRO_Scheduled_Today": "Tiene kCOUNT DRO programados el kDATE",
    "Due_by": "Debido por",
    "Starts_at": "Empieza en",
    
    // ViewDro
    "Assigned": "Asignado",
    "Completed": "Terminado",
    "Active": "Activo",
    
    //DASHBOARD
    "Last_Visit" : "Tu última visita fue en ",
    
    // Indicador de actividad
    "Refreshing": "Refrescante",
    "Loading": "Cargando",
    
    //Alerta
    "Alerta": "Alerta",
    "Password_Error": "Error de contraseña",
    "Error": "Error",
    
    // ErrorMesssage
    "Empty_Email": "Por favor ingrese su ID de correo electrónico",
    "Invalid_Email": "Por favor, introduzca una identificación de correo electrónico válida",
    "Empty_Password": "Introduzca la contraseña",
    "Password_Mismatch": "Las contraseñas no coinciden",
    "Logout_Message": "¿Está seguro que desea cerrar sesión?",
    "Logout_Offline_Message": "Si cierra la sesión en modo fuera de línea, perderá el progreso de su encuesta sin sincronización. \n \n ¿Está seguro que desea cerrar la sesión?" ,
    
    //Edit Profile
    
    "Edit_Profile" : "Kuorto pico" ,
    "Edit" : "Editar",
    "Done" : "Hecho",
    "Profile" : "Perfil",

    //Terms
    "Last_Updated" : "Última actualización",


    
]
