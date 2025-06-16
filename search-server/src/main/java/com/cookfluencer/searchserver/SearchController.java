package com.cookfluencer.searchserver;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    @PostMapping("/documents")
    public ResponseEntity<Void> addDocument(@RequestBody Document doc) throws Exception {
        searchService.addDocument(doc);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<Document>> search(@RequestParam("query") String query) throws Exception {
        List<Document> results = searchService.search(query);
        return ResponseEntity.ok(results);
    }
}
