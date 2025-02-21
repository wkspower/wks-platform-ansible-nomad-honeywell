package wks.authz

import future.keywords

default allow = false

has_client_role := {"client_case", "client_task", "client_record"}
has_manager_role := {"mgmt_form", "mgmt_case_def", "mgmt_record_type"}
has_email_to_case_role := {"email_to_case"}

allow {
    input.path == "case"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "case-definition"
    input.method in ["GET", "OPTIONS"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "record-type"
    input.method in ["GET", "OPTIONS"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "record"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "task"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "form"
    input.method in ["GET", "OPTIONS"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "variable"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "process-instance"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "process-definition"
    input.method in ["POST", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "queue"
    input.method in ["GET", "OPTIONS"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "case-email"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_user_profile
}

allow {
    input.path == "case-email"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    is_email_to_case_profile
}

allow {
    input.path == "record-type"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "form"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "process-definition"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "deployment"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "case-definition"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "message"
    input.method in ["POST", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "queue"
    input.method in ["GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS", "HEAD"]
    check_origin_request
    is_manager_profile
}

allow {
    input.path == "storage"
    input.method in ["GET", "POST", "OPTIONS", "HEAD"]
}

check_origin_request {
    input.allowed_origin == "localhost"
    input.host == "localhost"
}

check_origin_request {
    input.allowed_origin == "localhost"
    input.host == ""
}

check_origin_request {
    not is_null(input.org)
    startswith(input.host, input.org)
    input.allowed_origin == input.host
}

is_user_profile {
    some role in input.realm_access.roles
    has_client_role[role]
}

is_manager_profile {
    some role in input.realm_access.roles
    has_manager_role[role]
}

is_email_to_case_profile {
    some role in input.realm_access.roles
    has_email_to_case_role[role]
}
