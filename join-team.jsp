<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Join Team</title>
  <style>
   /* Global Styles */
       * {
         margin: 0;
         padding: 0;
         box-sizing: border-box;
       }

       body {
         background-color: #f0f4f8; /* Light background for contrast */
         font-family: 'Garamond', serif;
         display: flex;
         justify-content: center;
         align-items: center;
         height: 100vh;
         margin: 0;
         background-image: url('https://www.transparenttextures.com/patterns/white-linen.png'); /* Subtle texture for depth */
         background-size: cover;
       }

       .join-team-container {
         background-color: #ffffff;
         padding: 40px;
         border-radius: 12px;
         box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
         text-align: center;
         width: 100%;
         max-width: 380px;
         transition: transform 0.3s ease, box-shadow 0.3s ease;
       }

       .join-team-container:hover {
         transform: scale(1.05); /* Slight zoom effect */
         box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
       }

       h2 {
         color: #333;
         font-size: 28px;
         margin-bottom: 30px;
         font-family: 'Garamond', serif;
         font-weight: bold;
       }

       label {
         font-size: 18px;
         color: #555;
         font-family: 'Garamond', serif;
         text-align: left;
         display: block;
         margin-bottom: 5px;
       }

       input[type="text"] {
         width: 100%;
         padding: 12px;
         margin-bottom: 20px;
         border: 1px solid #ccc;
         border-radius: 4px;
         font-size: 16px;
         outline: none;
         transition: border-color 0.3s ease;
         font-family: 'Arial', sans-serif;
       }

       input[type="text"]:focus {
         border-color: #bf4080;
         box-shadow: 0 0 5px rgba(191, 64, 128, 0.5); /* Soft glow when focused */
       }

       button {
         background-color: #bf4080;
         color: white;
         border: none;
         padding: 14px 24px;
         font-size: 18px;
         width: 100%;
         cursor: pointer;
         border-radius: 8px;
         transition: background-color 0.3s ease;
         font-family: 'Garamond', serif;
       }

       button:hover {
         background-color: #9e3365; /* Darker shade for hover effect */
       }

       button:focus {
         outline: none;
       }

       #teamInfo {
         display: none;
         background-color: #fff;
         padding: 40px;
         border-radius: 12px;
         box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
         text-align: center;
         width: 100%;
         max-width: 380px;
         margin-top: 20px;
       }

       #teamCode, #projectNameDisplay {
         font-size: 20px;
         margin-bottom: 20px;
         color: #444;
         font-weight: bold;
       }

       #teamCode {
         color: #bf4080;
       }

       #open-editor-btn {
         background-color: #bf4080; /* Same color as the Create Team button */
         color: white;
         padding: 12px 24px;
         border-radius: 8px;
         border: none;
         font-size: 18px;
         cursor: pointer;
         transition: background-color 0.3s ease;
         font-family: 'Garamond', serif;
       }

       #open-editor-btn:hover {
         background-color: #9e3365; /* Darker shade for hover, same as Create Team button */
       }
  </style>
</head>
<body>

<%
    String teamCode = request.getParameter("teamCode");
    String projectName = null;
    String errorMessage = null;

    // JDBC connection variables
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Fetch the project name if team code is entered
    if (teamCode != null && !teamCode.trim().isEmpty()) {
        try {
            // 1. Establishing the JDBC connection (update with your DB connection details)
             Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://localhost:3306/COLLABORATIVE_EDITOR";  // Update the DB URL
            String dbUser = "root";  // Your DB username
            String dbPassword = "miruthula";  // Your DB password


            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

            // 2. SQL query to get the project name based on team code
            String sql = "SELECT project_name FROM teams WHERE team_code = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teamCode);  // Setting the team code

            rs = pstmt.executeQuery();

            // 3. If team code exists, fetch the project name
            if (rs.next()) {
                projectName = rs.getString("project_name");
            } else {
                errorMessage = "Invalid team code. Please try again.";
            }
        } catch (SQLException e) {
            errorMessage = "Database error: " + e.getMessage();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                errorMessage = "Error closing resources: " + e.getMessage();
            }
        }
    }
%>

<div class="join-team-container">
  <h2>Join a Team</h2>

  <!-- Username Input -->
  <label for="usernameInput">Enter your username</label>
  <input type="text" id="usernameInput" placeholder="Enter your username" required>

  <!-- Team Code Input -->
  <label for="teamCodeInput">Enter team code</label>
  <input type="text" id="teamCodeInput" placeholder="Enter team code" required>

  <button onclick="joinTeam()">Join Team</button>

  <p id="errorMessage" style="color: red;">
    <%= errorMessage != null ? errorMessage : "" %>
  </p> <!-- Error message -->
</div>

<% if (projectName != null) { %>
<!-- Team Info Section -->
<div id="teamInfo">
  <p id="teamCode">Team code: <%= teamCode %></p>
  <p id="projectNameDisplay">Project: <%= projectName %></p>
  <button id="open-editor-btn" onclick="window.location.href='index.jsp?teamCode=<%= teamCode %>'">Go to Editor</button>
</div>
<% } %>

<script>
  function joinTeam() {
      const username = document.getElementById('usernameInput').value;
      const teamCode = document.getElementById('teamCodeInput').value;

      if (username.trim() === '' || teamCode.trim() === '') {
        alert('Please fill in both your username and team code!');
        return;
      }

      // Submit the form with the team code to reload the page and fetch project name
      window.location.href = `index.jsp?teamCode=${teamCode}`;
  }
</script>
</body>
</html>
