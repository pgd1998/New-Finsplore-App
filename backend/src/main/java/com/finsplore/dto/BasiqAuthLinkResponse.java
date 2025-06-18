package com.finsplore.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class BasiqAuthLinkResponse {
    private Links links;

    public Links getLinks() {
        return links;
    }

    public void setLinks(Links links) {
        this.links = links;
    }

    public static class Links {
        private String _public;

        @JsonProperty("public")  // Maps JSON field "public" to variable _public
        public String getPublic() {
            return _public;
        }

        public void setPublic(String _public) {
            this._public = _public;
        }
    }
}
