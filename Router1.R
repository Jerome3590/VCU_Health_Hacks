library(plumber)

serve_api <- plumb("Patient_Engagement.R")
serve_api$run(host = "0.0.0.0", port = 7878)

