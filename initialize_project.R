# initialize_project.R
# One-stop script to bootstrap a hybrid R + Python project
# Supports both R-only and R+Python workflows

# --- CONFIG ---
use_python <- TRUE  # Set to FALSE if the project only uses R

# ---- 1. Install required R packages ----
required_r <- c("renv", "reticulate", "here")
installed_r <- rownames(installed.packages())

for (pkg in required_r) {
  if (!(pkg %in% installed_r)) {
    message("Installing R package: ", pkg)
    install.packages(pkg)
  }
}

# ---- 2. Restore renv snapshot ----
message("Restoring R packages with renv...")
library(renv)
renv::restore()

# ---- 3. Optional: Set up Python via Conda ----
if (use_python) {
  message("Setting up Conda environment...")
  library(here)
  source(here::here("setup_conda_env.R"))
} else {
  message("Skipping Conda/Python setup (R-only mode)")
}

# ---- 4. Confirm wiring ----
message("Active R library path: ", .libPaths()[1])
if (use_python) {
  message("Active Python: ", reticulate::py_config()$python)
}

message("✅ Project initialized. You're ready to code!")
