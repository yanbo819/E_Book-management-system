package cn_zjnu.model;

public class Order extends Books { // Extends Book now
    private int orderId;
    private int uid;
    private int quantity;
    private String date;
    private String status = "Pending";

    public Order() {
    }

    public Order(int orderId, int uid, int quantity, String date) {
        super();
        this.orderId = orderId;
        this.uid = uid;
        this.quantity = quantity;
        this.date = date;
    }

    public Order(int uid, int quantity, String date) { // Assuming this constructor is for creating new orders
        super();
        this.uid = uid;
        this.quantity = quantity;
        this.date = date;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        // You might want to include Book details in the toString as well if inherited data is relevant
        return "Order [orderId=" + orderId + ", uid=" + uid + ", quantity=" + quantity + ", date=" + date
                + ", Book Details: " + super.toString() + "]";
    }
}