package cn_zjnu.model;

public class Cart extends Books { // Extends Book now
    private int quantity;

    public Cart() {
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}