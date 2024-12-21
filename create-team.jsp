<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Team</title>
    <style>
                /* Resetting margin and padding for all elements */
                        * { margin: 0; padding: 0; box-sizing: border-box; }

                        /* Body styles */
                        body {
                            font-family: 'Garamond', serif;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            background-color: #f0f4f8;
                            background-image: url('https://www.transparenttextures.com/patterns/white-linen.png');
                            background-size: cover;
                        }

                        /* Container styles */
                        .container {
                            background-color: #ffffff;
                            padding: 40px;
                            border-radius: 12px;
                            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
                            text-align: center;
                            max-width: 500px;
                            transition: transform 0.3s ease, box-shadow 0.3s ease;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                        }

                        .container:hover {
                            transform: scale(1.05);
                            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
                        }

                        /* Title styling */
                        h2 {
                            color: #333;
                            font-size: 28px;
                            margin-bottom: 30px;
                            font-family: 'Garamond', serif;
                            font-weight: bold;
                        }

                        /* Label styling */
                        label {
                            font-size: 18px;
                            margin-bottom: 10px;
                            color: #333;
                            text-align: left;
                            display: block;
                            width: 100%;
                        }

                        /* Input field styling */
                        input[type="text"] {
                            width: 100%;
                            padding: 12px;
                            margin-bottom: 20px;
                            border: 1px solid #ccc;
                            border-radius: 8px;
                            font-size: 18px;
                            outline: none;
                            transition: border-color 0.3s ease;
                        }

                        input[type="text"]:focus {
                            border-color: #bf4080;
                        }

                        /* Button styling */
                        button {
                            background-color: #bf4080;
                            color: white;
                            border: none;
                            padding: 14px 24px;
                            font-size: 18px;
                            margin-top: 20px;
                            width: 100%;
                            cursor: pointer;
                            border-radius: 8px;
                            transition: background-color 0.3s ease;
                            font-family: 'Garamond', serif;
                        }

                        button:hover {
                            background-color: #9e3365;
                        }

                        /* Display details styling */
                        .details {
                            background-color: #f9f9f9;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                            margin-top: 20px;
                            width: 100%;
                            text-align: left;
                        }

                        .details p {
                            font-size: 18px;
                            margin: 10px 0;
                            color: #333;
                        }

                        .team-code {
                            font-weight: bold;
                            color: #bf4080;
                        }
    </style>
</head>
<body>
    <div class="container">
        <%
            // Database credentials
            String jdbcURL = "jdbc:mysql://localhost:3306/COLLABORATIVE_EDITOR"; // Replace with your DB URL
            String dbUsername = "root"; // Replace with your DB username
            String dbPassword = "miruthula"; // Replace with your DB password
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            // Get the username and project name from request parameters
            String username = request.getParameter("username");
            String projectName = request.getParameter("projectName");

            // Try to connect to the database and insert or fetch the data
            try {
                // Load MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish connection to the database
                conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

                // If the form hasn't been submitted yet, show the input form
                if (username == null || projectName == null) {
        %>
        <!-- Form to create a team -->
        <h2>Create a Team</h2>
        <form method="post" action="create-team.jsp">
            <label for="username">Enter your username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>

            <label for="projectName">Enter your project name</label>
            <input type="text" id="projectName" name="projectName" placeholder="Enter your project name" required>

            <button type="submit">Create Team</button>
        </form>
        <%
                } else {
                    // Generate team code using username and current date
                    String baseCode = username.length() > 4 ? username.substring(0, 4).toUpperCase() : username.toUpperCase();
                    String currentDate = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
                    String teamCode = baseCode + currentDate;

                    // Generate editor URL (Example: you could create a unique URL or reference it dynamically)
                    String editorURL = "http://localhost:8080/index.jsp?teamCode=" + teamCode;

                    // Insert data into the database (assuming you have a table `teams`)
                    String insertQuery = "INSERT INTO teams (username, project_name, team_code, url) VALUES (?, ?, ?, ?)";
                    ps = conn.prepareStatement(insertQuery);
                    ps.setString(1, username);
                    ps.setString(2, projectName);
                    ps.setString(3, teamCode);
                    ps.setString(4, editorURL);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
        %>
        <!-- Display team information -->
        <h2>Team Created Successfully</h2>
        <div class="details">
            <p><strong>Team Code:</strong> <span class="team-code"><%= teamCode %></span></p>
            <p><strong>Project Name:</strong> <%= projectName %></p>
            <p><strong>Editor URL:</strong> <%= editorURL %></p>
        </div>
        <form action="index.jsp" method="get">
            <button type="submit">Go to Editor</button>
        </form>
        <%
                    } else {
                        out.println("<p>Failed to create team. Please try again.</p>");
                    }
                }
            } catch (ClassNotFoundException e) {
                out.println("JDBC Driver not found: " + e.getMessage());
            } catch (SQLException e) {
                out.println("Database connection error: " + e.getMessage());
            } finally {
                // Close the database resources
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("Error closing resources: " + e.getMessage());
                }
            }
        %>
    </div>
</body>
</html>
