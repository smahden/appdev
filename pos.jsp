<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
   /*  HttpSession session = request.getSession(false); */
    if (session == null || session.getAttribute("userid") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cde1101_project", "root", "dbms");

    String query = "SELECT * FROM products";
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>

<html>
<head>
    <title>Point of Sales</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script>
        function openModal(productId, name, price, image) {
            document.getElementById('modalProductName').innerText = name;
            document.getElementById('modalProductImage').src = image;
            document.getElementById('productId').value = productId;
            document.getElementById('basePrice').value = price;
            calculateTotal();
            document.getElementById('productModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('productModal').style.display = 'none';
        }

        function calculateTotal() {
            let basePrice = parseFloat(document.getElementById('basePrice').value);
            let quantity = parseInt(document.getElementById('quantity').value);
            let size = document.querySelector('input[name="size"]:checked').value;
            let sizeIncrement = size === 'M' ? 10 : (size === 'L' ? 15 : 0);
            let addOns = document.querySelectorAll('input[name="addons"]:checked');
            let addOnsPrice = 0;
            addOns.forEach(addOn => {
                addOnsPrice += parseFloat(addOn.value);
            });
            let total = (basePrice + sizeIncrement + addOnsPrice) * quantity;
            document.getElementById('totalAmount').innerText = total.toFixed(2);
            document.getElementById('totalAmountInput').value = total.toFixed(2);
        }
    </script>
</head>
<body>
    <div class="pos-container">
        <h2>Point of Sales</h2>
        <div class="products-grid">
            <% while (rs.next()) { %>
                <div class="product" onclick="openModal(<%=rs.getInt("PRODUCTID")%>, '<%=rs.getString("NAME")%>', <%=rs.getDouble("PRICE")%>, '<%=rs.getString("IMAGE")%>')">
                    <img src="<%=rs.getString("IMAGE")%>" alt="<%=rs.getString("NAME")%>">
                    <h3><%=rs.getString("NAME")%></h3>
                    <p>₱ <%=rs.getDouble("PRICE")%></p>
                </div>
            <% } %>
        </div>
    </div>

    <div id="productModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2 id="modalProductName"></h2>
        <img id="modalProductImage" src="" alt="">
        <form action="POSServlet" method="post">
                <input type="hidden" id="productId" name="productId">
                <input type="hidden" id="basePrice" name="basePrice">
                <input type="hidden" id="totalAmountInput" name="totalAmount">
                <label for="quantity">Quantity:</label>
                <button type="button" onclick="document.getElementById('quantity').stepDown(); calculateTotal();">-</button>
                <input type="number" id="quantity" name="quantity" value="1" min="1" onchange="calculateTotal()">
                <button type="button" onclick="document.getElementById('quantity').stepUp(); calculateTotal();">+</button>
                <br><br>
                <label>Size:</label>
                <input type="radio" name="size" value="S" checked onclick="calculateTotal()"> S
                <input type="radio" name="size" value="M" onclick="calculateTotal()"> M (+₱ 10)
                <input type="radio" name="size" value="L" onclick="calculateTotal()"> L (+₱ 15)
                <br><br>
                <label>Sugar Level:</label>
                <input type="radio" name="sugarLevel" value="25%" checked> 25%
                <input type="radio" name="sugarLevel" value="50%"> 50%
                <input type="radio" name="sugarLevel" value="75%"> 75%
                <input type="radio" name="sugarLevel" value="100%"> 100%
                <br><br>
                <label>Ice Level:</label>
                <input type="radio" name="iceLevel" value="No Ice" checked> No Ice
                <input type="radio" name="iceLevel" value="Less Ice"> Less Ice
                <input type="radio" name="iceLevel" value="Normal"> Normal
                <br><br>
                <label>Add Ons:</label>
                <input type="checkbox" name="addons" value="15" onclick="calculateTotal()"> Pearls (+₱ 15)
                <input type="checkbox" name="addons" value="30" onclick="calculateTotal()"> Pudding (+₱ 30)
                <input type="checkbox" name="addons" value="20" onclick="calculateTotal()"> Cheese (+₱ 20)
                <br><br>
                <label>Total Amount: ₱ <span id="totalAmount">0.00</span></label>
                <br><br>
                <button type="submit">Submit Order</button>
            </form>
        </div>
    </div>
</body>
</html>
<%
    con.close();
%>
