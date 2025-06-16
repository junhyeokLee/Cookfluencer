package com.cookfluencer.searchserver;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class SearchService {

    private final Analyzer analyzer = new StandardAnalyzer();
    private final Directory index = new RAMDirectory();

    public void addDocument(com.cookfluencer.searchserver.Document doc) throws Exception {
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        try (IndexWriter writer = new IndexWriter(index, config)) {
            Document luceneDoc = new Document();
            luceneDoc.add(new StringField("id", doc.getId(), Field.Store.YES));
            luceneDoc.add(new TextField("title", doc.getTitle(), Field.Store.YES));
            luceneDoc.add(new TextField("content", doc.getContent(), Field.Store.YES));
            writer.addDocument(luceneDoc);
        }
    }

    public List<com.cookfluencer.searchserver.Document> search(String queryStr) throws Exception {
        List<com.cookfluencer.searchserver.Document> results = new ArrayList<>();
        Query q = new QueryParser("content", analyzer).parse(queryStr);
        try (DirectoryReader reader = DirectoryReader.open(index)) {
            IndexSearcher searcher = new IndexSearcher(reader);
            TopDocs docs = searcher.search(q, 10);
            for (ScoreDoc sd : docs.scoreDocs) {
                Document d = searcher.doc(sd.doc);
                results.add(new com.cookfluencer.searchserver.Document(
                        d.get("id"), d.get("title"), d.get("content")));
            }
        }
        return results;
    }
}
