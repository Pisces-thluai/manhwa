/**
 * Authentication System
 * Handles user registration, login, profile management and authentication state
 */
document.addEventListener('DOMContentLoaded', function() {
    initAuth();
});

/**
 * Initialize authentication features
 */
function initAuth() {
    // Check if user is logged in
    const isLoggedIn = checkLoginStatus();
    updateUIForAuthState(isLoggedIn);
    
    // Initialize login form
    const loginForm = document.querySelector('.login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);
    }
    
    // Initialize register form
    const registerForm = document.querySelector('.register-form');
    if (registerForm) {
        registerForm.addEventListener('submit', handleRegistration);
    }
    
    // Initialize forgot password
    const forgotPasswordLink = document.querySelector('.forgot-password');
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', handleForgotPassword);
    }
    
    // Initialize logout
    const logoutBtn = document.querySelector('.btn-logout');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
}

/**
 * Check if user is logged in
 */
function checkLoginStatus() {
    const token = localStorage.getItem('authToken');
    const userData = localStorage.getItem('userData');
    
    if (!token || !userData) {
        return false;
    }
    
    // Check if token is expired
    try {
        const user = JSON.parse(userData);
        const tokenExpiry = user.tokenExpiry;
        
        if (tokenExpiry && new Date(tokenExpiry) < new Date()) {
            // Token expired
            clearAuthData();
            return false;
        }
        
        return true;
    } catch (e) {
        console.error('Error parsing user data', e);
        clearAuthData();
        return false;
    }
}

/**
 * Update UI based on authentication state
 */
function updateUIForAuthState(isLoggedIn) {
    const authLinks = document.querySelector('.auth-links');
    if (!authLinks) return;
    
    if (isLoggedIn) {
        // Get user data
        const userData = JSON.parse(localStorage.getItem('userData'));
        
        // Replace login/register with user profile
        authLinks.innerHTML = `
            <div class="user-dropdown">
                <a href="#" class="user-profile">
                    <img src="${userData.avatar || '../images/default-avatar.png'}" alt="Profile">
                    <span>${userData.username}</span>
                </a>
                <div class="user-dropdown-content">
                    <a href="../profile.html">Profile</a>
                    <a href="../bookmarks.html">Bookmarks</a>
                    <a href="../reading-history.html">History</a>
                    <a href="#" class="btn-logout">Logout</a>
                </div>
            </div>
        `;
        
        // Add event listener to dropdown menu
        const userProfile = authLinks.querySelector('.user-profile');
        if (userProfile) {
            userProfile.addEventListener('click', function(e) {
                e.preventDefault();
                const dropdown = authLinks.querySelector('.user-dropdown-content');
                dropdown.classList.toggle('show');
            });
        }
        
        // Add logout event listener
        const logoutBtn = authLinks.querySelector('.btn-logout');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', handleLogout);
        }
    } else {
        // Show login/register links
        authLinks.innerHTML = `
            <a href="../login.html" class="btn-login">Login</a>
            <a href="../register.html" class="btn-register">Register</a>
        `;
    }
}

/**
 * Handle login form submission
 */
function handleLogin(e) {
    e.preventDefault();
    
    // Get form data
    const form = e.target;
    const username = form.querySelector('input[name="username"]').value;
    const password = form.querySelector('input[name="password"]').value;
    const rememberMe = form.querySelector('input[name="remember-me"]')?.checked || false;
    
    // Validate form
    if (!username || !password) {
        showAuthMessage('Please enter both username and password', 'error');
        return;
    }
    
    // For demo purposes, we'll use localStorage instead of a real backend
    // In a real app, this would be an API call
    simulateLoginAPI(username, password, rememberMe)
        .then(response => {
            if (response.success) {
                // Save auth data
                saveAuthData(response.data, rememberMe);
                
                // Show success message
                showAuthMessage('Login successful! Redirecting...', 'success');
                
                // Redirect to homepage after delay
                setTimeout(() => {
                    window.location.href = '../index.html';
                }, 1500);
            } else {
                showAuthMessage(response.message, 'error');
            }
        })
        .catch(error => {
            showAuthMessage('An error occurred during login', 'error');
            console.error(error);
        });
}

/**
 * Handle registration form submission
 */
function handleRegistration(e) {
    e.preventDefault();
    
    // Get form data
    const form = e.target;
    const username = form.querySelector('input[name="username"]').value;
    const email = form.querySelector('input[name="email"]').value;
    const password = form.querySelector('input[name="password"]').value;
    const confirmPassword = form.querySelector('input[name="confirm-password"]').value;
    
    // Validate form
    if (!username || !email || !password || !confirmPassword) {
        showAuthMessage('Please fill in all fields', 'error');
        return;
    }
    
    if (password !== confirmPassword) {
        showAuthMessage('Passwords do not match', 'error');
        return;
    }
    
    // For demo purposes, we'll use localStorage instead of a real backend
    // In a real app, this would be an API call
    simulateRegisterAPI(username, email, password)
        .then(response => {
            if (response.success) {
                // Show success message
                showAuthMessage('Registration successful! You can now login.', 'success');
                
                // Redirect to login page after delay
                setTimeout(() => {
                    window.location.href = '../login.html';
                }, 2000);
            } else {
                showAuthMessage(response.message, 'error');
            }
        })
        .catch(error => {
            showAuthMessage('An error occurred during registration', 'error');
            console.error(error);
        });
}

/**
 * Handle forgot password link click
 */
function handleForgotPassword(e) {
    e.preventDefault();
    
    const email = prompt('Enter your email address to reset your password:');
    if (!email) return;
    
    // For demo purposes, we'll just show a message
    showAuthMessage('If an account exists with this email, a password reset link has been sent.', 'success');
}

/**
 * Handle logout
 */
function handleLogout(e) {
    if (e) e.preventDefault();
    
    // Clear auth data
    clearAuthData();
    
    // Show message
    showToast('You have been logged out successfully');
    
    // Update UI
    updateUIForAuthState(false);
    
    // Redirect to homepage
    window.location.href = '../index.html';
}

/**
 * Save authentication data to localStorage
 */
function saveAuthData(data, rememberMe) {
    const expiry = rememberMe ? new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) : new Date(Date.now() + 24 * 60 * 60 * 1000);
    
    const userData = {
        ...data,
        tokenExpiry: expiry.toISOString()
    };
    
    localStorage.setItem('authToken', data.token);
    localStorage.setItem('userData', JSON.stringify(userData));
}

/**
 * Clear authentication data from localStorage
 */
function clearAuthData() {
    localStorage.removeItem('authToken');
    localStorage.removeItem('userData');
}

/**
 * Show authentication message
 */
function showAuthMessage(message, type = 'info') {
    // Find or create message container
    let messageContainer = document.querySelector('.auth-message');
    
    if (!messageContainer) {
        messageContainer = document.createElement('div');
        messageContainer.className = 'auth-message';
        
        // Insert after the form
        const form = document.querySelector('.login-form, .register-form');
        if (form) {
            form.insertAdjacentElement('afterend', messageContainer);
        }
    }
    
    // Set message and type
    messageContainer.textContent = message;
    messageContainer.className = `auth-message ${type}`;
    
    // Clear message after 5 seconds
    setTimeout(() => {
        messageContainer.textContent = '';
        messageContainer.className = 'auth-message';
    }, 5000);
}

/**
 * Show toast notification
 */
function showToast(message, duration = 3000) {
    // Create toast if it doesn't exist
    let toast = document.querySelector('.toast');
    
    if (!toast) {
        toast = document.createElement('div');
        toast.className = 'toast';
        document.body.appendChild(toast);
    }
    
    // Set message and show
    toast.textContent = message;
    toast.classList.add('show');
    
    // Hide after duration
    setTimeout(() => {
        toast.classList.remove('show');
    }, duration);
}

// --------------------------------
// Mock API functions for demo
// In a real app, these would be real API calls
// --------------------------------

/**
 * Simulate login API call
 */
function simulateLoginAPI(username, password) {
    return new Promise((resolve) => {
        setTimeout(() => {
            // Get users from localStorage
            const users = JSON.parse(localStorage.getItem('users')) || [];
            
            // Find user by username
            const user = users.find(u => u.username === username);
            
            if (!user) {
                resolve({ success: false, message: 'User not found' });
                return;
            }
            
            // In a real app, we would use proper password hashing
            if (user.password !== password) {
                resolve({ success: false, message: 'Incorrect password' });
                return;
            }
            
            // Generate a fake token
            const token = 'token_' + Math.random().toString(36).substr(2);
            
            // Return user data (without password)
            const { password: _, ...userData } = user;
            
            resolve({
                success: true,
                data: {
                    ...userData,
                    token
                }
            });
        }, 1000); // Simulate network delay
    });
}

/**
 * Simulate register API call
 */
function simulateRegisterAPI(username, email, password) {
    return new Promise((resolve) => {
        setTimeout(() => {
            // Get users from localStorage
            const users = JSON.parse(localStorage.getItem('users')) || [];
            
            // Check if username exists
            if (users.some(u => u.username === username)) {
                resolve({ success: false, message: 'Username already exists' });
                return;
            }
            
            // Check if email exists
            if (users.some(u => u.email === email)) {
                resolve({ success: false, message: 'Email already exists' });
                return;
            }
            
            // Create new user
            const newUser = {
                id: Date.now().toString(),
                username,
                email,
                password, // In a real app, we would hash the password
                createdAt: new Date().toISOString(),
                bookmarks: [],
                readingHistory: [],
                preferences: {
                    theme: 'dark',
                    fontSize: 'medium',
                    readingDirection: 'vertical',
                    notifications: true,
                    familyMode: true
                }
            };
            
            // Add to users
            users.push(newUser);
            
            // Save back to localStorage
            localStorage.setItem('users', JSON.stringify(users));
            
            resolve({ success: true });
        }, 1000); // Simulate network delay
    });
} 