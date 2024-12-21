<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
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

    /* Login Container */
    .login-container {
      background-color: #ffffff;
      padding: 40px;
      border-radius: 12px;
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
      text-align: center;
      width: 100%;
      max-width: 380px;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    /* Hover effect on login container */
    .login-container:hover {
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

    button {
      background-color: #bf4080;
      color: white;
      border: none;
      padding: 14px 24px;
      font-size: 18px;
      margin: 15px 0;
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
  </style>
</head>
<body>
<div class="login-container">
  <h2>Welcome to the Editor</h2>
  <button onclick="location.href='create-team.jsp'">Create Team</button>
  <button onclick="location.href='join-team.jsp'">Join Team</button>
</div>
</body>
</html>
