# initialize_project.R
library(here)
library(renv)

cat("👋 Welcome to your new project!\n")

if (!file.exists("renv.lock")) {
  cat("🌀 No renv.lock found — initializing renv (R will restart)...\n")
  renv::init()
  cat("⚠️ Please re-run this script after R restarts to complete setup.\n")
} else {
  source(here("init_environment.R"))
}



