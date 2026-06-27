package com.smartstock.erp.resource;

import com.smartstock.erp.model.Product;
import com.smartstock.erp.repository.ProductRepository;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import java.util.List;

@Path("/products")
@RequestScoped
public class ProductResource {

    @Inject
    private ProductRepository productRepository;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @GET
    @Path("/stock")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Product> getStockStatus() {
        return productRepository.findAll();
    }
}
