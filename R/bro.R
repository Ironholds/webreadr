# Read in file metadata
get_bro_metadata <- function(file){
  
  # Read the data in, check it and name it
  metadata <- strsplit(x = readr::read_lines(file, n_max = 7), split = "\\t")
  if(!all(grepl(x = metadata, pattern = "#"))){
    stop("This file does not contain properly formatted comments and cannot be read in.")
  }
  
  names(metadata) <- c("separator", "set_separator", "empty_field", "unset_field",
                       "log_type", "start_timestamp", "fields")
  
  # Extract the components
  metadata$separator <- unlist(strsplit(metadata$separator, " ", fixed = TRUE))[2]
  metadata$separator <- ifelse(metadata$separator == "\\x09", "\t", metadata$separator)
  metadata$set_separator <- metadata$set_separator[2]
  metadata$empty_field <- metadata$empty_field[2]
  metadata$unset_field <- metadata$unset_field[2]
  metadata$log_type <- metadata$log_type[2]
  metadata$start_timestamp <- metadata$start_timestamp[2]
  metadata$fields <- metadata$fields[2:length(metadata$fields)]
  
  # Return
  return(metadata)
}

# Select which fields are in the file, since some bro files at least have
# optional fields
select_fields <- function(metadata, old_names, new_names){
  
  which_in <- which(old_names %in% metadata$fields)
  metadata$types <- paste(names(new_names)[which_in], collapse = "")
  metadata$names <- unname(new_names[which_in])
  return(metadata)
}

# Base reader
read_bro_base <- function(file, metadata){
  
  # Generate NA values
  na_vals <- c("", "NA", metadata$empty_field, metadata$unset_field)
  return(readr::read_delim(file, delim = metadata$separator, col_types = metadata$types,
                           col_names = metadata$names, na = na_vals, comment = "#"))
  
}


# App stats files
read_bro_app_stats <- function(file, metadata){
  
  # Set names
  col_names <- c("timestamp", "interval", "app", "unique_hosts", "hits", "total_bytes")
  names(col_names) <- c("n", "n", "c", "i", "i", "i")
  old_names <- c("ts", "ts_delta", "app", "uniq_hosts", "hits", "bytes")
  
  # Get additional metadata
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps and return
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  return(data)
}

# Conn files
read_bro_conn <- function(file, metadata){
  
  # Specify colum names and types
  col_names <- c("timestamp", "uid", "origin_host", "origin_port", "response_host", 
                 "response_port", "protocol", "service", "duration", "origin_bytes", 
                 "response_bytes", "conn_state", "origin_local", "response_local", 
                 "missed_bytes", "history", "origin_packets", "origin_bytes", 
                 "response_packets", "response_bytes")
  names(col_names) <- c("n", "c", "c", "n", "c", "n", "c", "c", "n", "n", "n", "c", 
                        "n", "n", "c", "i", "i", "i", "i", "c")
  old_names <- c("ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", 
                 "proto", "service", "duration", "orig_bytes", "resp_bytes", "conn_state", 
                 "local_orig", "missed_bytes", "history", "orig_pkts", "orig_ip_bytes", 
                 "resp_pkts", "resp_ip_bytes", "tunnel_parents")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps and return
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  return(data)
}

# DHCP files
read_bro_dhcp <- function(file, metadata){
  
  # Retrieve metadata
  metadata <- get_bro_metadata(file)
  
  # Specify colum names and types
  col_names <- c("timestamp", "uid", "origin_host", "origin_port", "response_host",
                 "response_port", "mac_address", "assigned_ip", "lease_time",
                 "transaction_id")
  names(col_names) <- c("n", "c", "c", "n", "c", "n", "c", "c", "d", "n")
  old_names <- c("ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", 
                 "mac", "assigned_ip", "lease_time", "trans_id")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  
  #Return!
  return(data)
}

# DNS files
read_bro_dns <- function(file, metadata){
  
  # Specify colum names and types
  col_names <- c("timestamp", "uid", "origin_host", "origin_port", "response_host",
                 "response_port", "protocol", "transaction_id", "query",
                 "query_class", "class_name", "query_type", "type_name",
                 "response_code", "response_name", "auth_answer", "truncation",
                 "recursion_desired", "recursion_available", "Z", "answers",
                 "caching_intervals", "rejected", "total_answers", "total_replies",
                 "saw_query", "saw_reply", "auth_response", "additional")
  
  names(col_names) <- c("n", "c", "c", "i", "c", "i", "c",
                        "i", "c", "i", "c", "i", "c", "i", "c", "l",
                        "l", "l", "l", "i", "c", "n", "l", "n", "n",
                        "l", "l", "c", "c")
  old_names <- c("ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", 
                 "proto", "trans_id", "query", "qclass", "qclass_name", "qtype", 
                 "qtype_name", "rcode", "rcode_name", "AA", "TC", "RD", "RA", 
                 "Z", "answers", "TTLs", "rejected", "total_answers", "total_replies",
                 "saw_query", "saw_reply", "auth", "addl")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  
  # Return!
  return(data)
}

read_bro_ftp <- function(file, metadata){
  
  col_names <- c("timestamp", "uid", "origin_host", "origin_port", "response_host",
                 "response_port", "user", "password", "command",
                 "argument", "mime_type", "file_size", "reply_code",
                 "reply_message", "passive_chan","chan_origin_host", "chan_response_host",
                 "chan_response_port", "working_dir", "command_timestamp", "command_cmd",
                 "command_arg", "command_seq", "pending_timestamp", "pending_command", "pending_arg",
                 "pending_seq", "is_passive", "capture_password", "file_uid", "last_auth")
  
  names(col_names) <- c("n", "c", "c", "i", "c", "i", "c",
                        "c", "c", "c", "c", "n", "i", "c", "l",
                        "c", "c", "i", "c", "n", "c", "c", "i",
                        "n", "c", "c", "i", "l", "l", "c", "c")
  
  old_names <- c("ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", 
                 "user", "password", "command", "arg", "mime_type", "file_size", 
                 "reply_code", "reply_msg", "data_channel.passive", "data_channel.orig_h", 
                 "data_channel.resp_h", "data_channel.resp_p", "cwd","cmdarg.ts", "cmdarg.cmd",
                 "cmdarg.arg", "cmdarg.seq", "pending_commands.ts", "pending_commands.cmd",
                 "pending_commands.arg", "pending_commands.seq", "passive", "capture_password",
                 "fuid", "last_auth_requested")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  
  if("pending_timestamp" %in% metadata$names){
    data$pending_timestamp <- unix_to_posix(data$pending_timestamp)
  }
  
  if("command_timestamp" %in% metadata$names){
    data$command_timestamp <- unix_to_posix(data$command_timestamp)
  }
  
  # Return!
  return(data)
}

read_bro_files <- function(file, metadata){
  
  col_names <- c("timestamp", "fuid", "origin_host", "destination_host", "conn_uids",
                 "source", "depth", "analysers", "mime_type",
                 "filename", "duration", "local_origin", "is_origin",
                 "bytes_seen", "total_bytes", "missing_bytes", "overflow_bytes",
                 "timedout", "parent_fuid", "md5", "sha1", "sha256", "x509_timestamp",
                 "x509_id", "x509_certificate_version", "x509_certificate_serial",
                 "x509_certificate_subject", "x509_certificate_issuer", "x509_certificate_name",
                 "x509_certificate_invalid_before", "x509_certificate_invalid_after",
                 "x509_certificate_key_algorithm", "x509_certificate_sig_algorithm",
                 "x509_certificate_key_type", "x509_certificate_key_length", "x509_certificate_exponent",
                 "x509_certificate_curve", "x509_handle", "x509_extensions",
                 "x509_san_dns", "x509_san_uri", "x509_san_email", "x509_san_ip", "x509_san_other",
                 "x509_constraints_ca", "x509_constraints_path_length", "x509_logcert",
                 "extracted")
  names(col_names) <- c("d", "c", "c", "c", "c", "c", "i", "c", "c", "c", "d", "l",
                        "l", "d", "d", "d", "d", "l", "c", "c", "c", "c", "n",
                        "c", "n", "c", "c", "c", "c", "c", "c", "c", "c", "c",
                        "i", "c", "c", "c", "c", "c", "c", "c", "c", "l", "l",
                        "i", "l", "c")
  
  old_names <- c("ts", "fuid", "tx_hosts", "rx_hosts", "conn_uids", "source", 
                 "depth", "analyzers", "mime_type", "filename", "duration", "local_orig", 
                 "is_orig", "seen_bytes", "total_bytes", "missing_bytes", "overflow_bytes", 
                 "timedout", "parent_fuid", "md5", "sha1", "sha256", "x509.ts", "x509.id",
                 "x509.certificate.version","x509.certificate.serial","x509.certificate.subject",
                 "x509.certificate.issuer", "x509.certificate.cn", "x509.certificate.not_valid_before",
                 "x509.certificate.not_valid_after", "x509.certificate.key_alg", "x509.certificate.sig_alg",
                 "x509.certificate.key_type", "x509.certificate.key_length", "x509.certificate.exponent",
                 "x509.certificate.curve", "x509.handle", "x509.extensions", "x509.san.dns", "x509.san.url",
                 "x509.san.email", "x509.san.ip", "x509.san.other_fields", "x509.basic_constraints.ca",
                 "x509.basic_constraints.path_len", "x509.logcert", "extracted")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  
  if("x509_timestamp" %in% metadata$names){
    data$x509_timestamp <- unix_to_posix(data$x509_timestamp)
  }
  
  # Return!
  return(data)
}

read_bro_http <- function(file, metadata){
  
  col_names <- c("timestamp", "uid", "origin_host", "origin_port", "response_host",
                 "response_port", "transaction_depth", "method", "host", "uri",
                 "referrer", "user_agent", "request_body_length", "response_body_length",
                 "status_code", "status_message", "info_code", "info_message", "filename",
                 "tags", "username", "password", "capture_password", "proxied", "range_request",
                 "origin_fuids", "origin_mime_types", "response_fuids", "response_mime_types",
                 "current_entity", "origin_mime_depth", "response_mime_depth", "client_header_names",
                 "server_header_names", "omniture", "cookie_variables", "uri_variables")
  names(col_names) <- c("n", "c", "c", "i", "c", "i", "i", "c", "c", "c", "c", "c", "i",
                        "i", "i", "c", "i", "c", "c", "c", "c", "c", "l", "c", "l", "c",
                        "c", "c", "c", "c", "i", "i", "c", "c", "l", "c", "c")
  
  old_names <- c("ts", "uid", "id.orig_h", "id.orig_p", "id.resp_h", "id.resp_p", "trans_depth",
                 "method", "host", "uri", "referrer", "user_agent", "request_body_len",
                 "response_body_len", "status_code", "status_msg", "info_code", "info_msg",
                 "filename", "tags", "username", "password", "capture_password", "proxied",
                 "range_request", "orig_fuids", "orig_mime_types", "resp_fuids", "resp_mime_types",
                 "current_entity", "orig_mime_depth", "resp_mime_depth", "client_header_names",
                 "server_header_names", "omniture", "cookie_vars", "uri_vars")
  
  # Update metadata with required fields
  metadata <- select_fields(metadata, old_names, col_names)
  
  # Read the data in, format the timestamps
  data <- read_bro_base(file, metadata)
  data$timestamp <- unix_to_posix(data$timestamp)
  
  # Return!
  return(data)
}

read_bro <- function(file){
  
  # Read the metadata to check what kind of file we have.
  metadata <- get_bro_metadata(file)
  
  # Switch through file types
  if(metadata$log_type == "app_stats"){
    return(read_bro_app_stats(file, metadata))
  }
  
  if(metadata$log_type == "conn"){
    return(read_bro_conn(file, metadata))
  }
  
  if(metadata$log_type == "dhcp"){
    return(read_bro_dhcp(file, metadata))
  }
  
  if(metadata$log_type == "dns"){
    return(read_bro_dns(file, metadata))
  }
  
  if(metadata$log_type == "ftp"){
    return(read_bro_ftp(file, metadata))
  }
  
  if(metadata$log_type == "files"){
    return(read_bro_files(file, metadata))
  }
  
  if(metadata$log_type == "http"){
    return(read_bro_http(file, metadata))
  }
  
  stop("File type not recognised/supported")
}
