
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class POSServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userid") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userid");
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String size = request.getParameter("size");
        String sugarLevel = request.getParameter("sugarLevel");
        String iceLevel = request.getParameter("iceLevel");
        String addOns = "";
        String[] addOnsArray = request.getParameterValues("addons");
        if (addOnsArray != null && addOnsArray.length > 0) {
            addOns = String.join(", ", addOnsArray);
        }
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cde1101_project", "root", "dbms");

            String query = "INSERT INTO sales (USERID, PRODUCTID, QUANTITY, SIZE, SUGAR_LEVEL, ICE_LEVEL, ADD_ONS, TOTAL_AMOUNT, DATE_OF_PURCHASE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, userId);
            pst.setInt(2, productId);
            pst.setInt(3, quantity);
            pst.setString(4, size);
            pst.setString(5, sugarLevel);
            pst.setString(6, iceLevel);
            pst.setString(7, addOns);
            pst.setDouble(8, totalAmount);
            pst.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

            int rowsAffected = pst.executeUpdate();
            con.close();

            if (rowsAffected > 0) {
                // Print out the details after insertion
                PrintWriter out = response.getWriter();
                out.println("Details added to the database successfully:");
                out.println("User ID: " + userId);
                out.println("Product ID: " + productId);
                out.println("Quantity: " + quantity);
                out.println("Size: " + size);
                out.println("Sugar Level: " + sugarLevel);
                out.println("Ice Level: " + iceLevel);
                out.println("Add Ons: " + addOns);
                out.println("Total Amount: " + totalAmount);
                out.println("Date of Purchase: " + new Timestamp(System.currentTimeMillis()));
                out.close();
            } else {
                response.getWriter().println("Error inserting details into the database.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("An error occurred.");
        }
    }
}
