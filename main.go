package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
  staticPath := os.Getenv("STATIC_FILES_PATH")
  if staticPath == "" {
    staticPath = "./static"
  }

  http.Handle("/", http.FileServer(http.Dir(staticPath)))

  fmt.Println("Server is starting on port 9999...")
  err := http.ListenAndServe(":9999", nil)
  if err != nil {
    fmt.Println("Error starting server:", err)
  }
}
