# initialize_project.R
# One-stop script to bootstrap a hybrid R + Python project
# Supports both R-only and R+Python workflows

# --- CONFIG ---
use_python <- TRUE  # Set to FALSE if the project only uses R

# ---- Safety check: must be in project root ----
required_files <- c("initialize_project.R", "setup_conda_env.R")
missing <- required_files[!file.exists(required_files)]
if (length(missing)) {
  stop("⚠️ Please open the project via the .Rproj file or set the working directory to the project root. Missing files: ", paste(missing, collapse = ", "))
}

# ---- 1. Install required R packages ----
required_r <- c("renv", "reticulate", "here")
installed_r <- rownames(installed.packages())

for (pkg in required_r) {
  if (!(pkg %in% installed_r)) {
    message("Installing R package: ", pkg)
    install.packages(pkg)
  }
}

# ---- 2. Initialize or restore renv environment ----
message("Setting up R environment with renv...")

library(renv)
if (file.exists("renv.lock")) {
  message("Found renv.lock file — restoring environment...")
  renv::restore()
} else {
  message("No renv.lock found — initializing new renv project...")
  renv::init(bare = TRUE)
}

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


