package com.chtrembl.petstoreapp.model;

public class FunctionResponse {
    private String status;

    public FunctionResponse() {
    }

    public FunctionResponse(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
