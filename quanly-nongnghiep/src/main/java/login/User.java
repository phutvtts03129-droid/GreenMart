package login;


import java.math.BigDecimal;
import java.sql.Timestamp;

public class User {
    private int id;
    private String fullname;
    private String username;
    private String email;
    private String password;
    private String role;
    private BigDecimal salary;
    private boolean status;
    private Timestamp createdAt;

    public User() {}

    public User(String fullname, String username, String email, String password, String role, BigDecimal salary) {
        this.fullname = fullname;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.salary = salary;
        this.status = true;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public BigDecimal getSalary() { return salary; }
    public void setSalary(BigDecimal salary) { this.salary = salary; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
}