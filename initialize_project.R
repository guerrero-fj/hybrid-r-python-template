# initialize_project.R
# Unified R project initialization for hybrid R + Python Quarto workflows

library(here)
library(renv)
library(reticulate)

env_name <- "quarto-env-conda"
required_python_packages <- c("pandas", "matplotlib", "wordcloud", "nltk")
pending_flag <- ".pending_setup"

cat("👋 Welcome to your new project!\n")

# Step 1: First-time renv init
if (!file.exists("renv.lock") && !file.exists(pending_flag)) {
  cat("🌀 No renv.lock found — initializing renv (R will restart)...\n")
  file.create(pending_flag)
  renv::init()
  return(invisible(NULL))
}

# Step 2: Post-restart continuation
if (file.exists(pending_flag)) {
  file.remove(pending_flag)
  cat("✅ Renv setup complete. Continuing project initialization...\n")
}

# Step 3: Ask about Python use
use_python <- readline("This project supports hybrid R + Python workflows. Will you use Python in this project? (y/n): ")
use_python <- tolower(trimws(use_python))
if (use_python == "") use_python <- "n"

if (use_python == "y") {
  if (!(env_name %in% conda_list()$name)) {
    cat(sprintf("📦 Creating Conda environment '%s'...\n", env_name))
    conda_create(env_name, packages = required_python_packages)
  } else {
    cat(sprintf("🔁 Conda environment '%s' already exists. Activating...\n", env_name))
  }

  use_condaenv(env_name, required = TRUE)

  ensure_python_package <- function(pkg, env = env_name) {
    current <- conda_list_packages(envname = env)$package
    if (!(pkg %in% current)) {
      message(sprintf("Installing Python package: '%s'", pkg))
      conda_install(envname = env, packages = pkg, pip = FALSE)
    }
  }

  export_conda_env <- function(env = env_name, file = "environment.yml") {
    conda_export(envname = env, filename = file)
  }

  cat("✅ Python environment ready and linked via reticulate.\n")
} else {
  cat("ℹ️ Skipping Python setup. You can enable it later by editing this file.\n")
}

cat("🎉 Project initialized successfully! Happy coding.\n")



