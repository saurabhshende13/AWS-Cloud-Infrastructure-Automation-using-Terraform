# AWS-Cloud-Infrastructure-Automation-using-Terraform
Based on the architecture diagram, this project represents a **Multi-Tier Scalable Web Application Deployment on AWS** using Terraform. Below is the **GitHub README documentation format** for your project.  

---

## 📖 **Project Overview**  
This project automates the deployment of a **highly available and scalable web application** on AWS using **Terraform**. The architecture follows a **multi-tier model**, separating resources into public and private subnets for security and efficiency. The infrastructure includes **ALB (Application Load Balancer), Auto Scaling, NGINX web servers, RDS (Relational Database Service), Amazon EFS, and Bastion hosts** for secure access.

---

## 📜 **Architecture Breakdown**
The deployment consists of multiple components working together:

### **1️⃣ Networking Layer (VPC & Subnets)**
- **Virtual Private Cloud (VPC)** is used to isolate the infrastructure.
- **Public Subnets (1 & 2)** for Bastion Hosts and NGINX servers.
- **Private Subnets (3 & 4)** for Web Servers.
- **Private Subnets (5 & 6)** for **RDS (Amazon Relational Database Service)** and **Amazon EFS**.
- **Internet Gateway** allows public internet access.
- **NAT Gateway** enables private instances to access the internet for updates.

### **2️⃣ Load Balancing & Auto Scaling**
- **ALB (Application Load Balancer)** distributes traffic between NGINX instances.
- **Auto Scaling Groups** ensure that instances scale up/down based on demand.

### **3️⃣ Compute Layer**
- **NGINX Web Servers (Public Subnets)** handle incoming traffic and forward requests.
- **Web Application Servers (Private Subnets)** process requests.

### **4️⃣ Storage & Database**
- **Amazon RDS** is used to store structured data securely.
- **Amazon EFS** (Elastic File System) ensures shared storage across multiple instances.

### **5️⃣ Bastion Host (Jump Server)**
- **Used for secure SSH access** to private instances.

---

## 🚀 **How It Works**
1. **Users** access the application via a **Route 53 domain name**.
2. The request is routed through the **ALB**, which balances traffic across NGINX instances in public subnets.
3. NGINX forwards the request to **web servers in private subnets**.
4. Web servers fetch/store data from **Amazon RDS** and shared files from **Amazon EFS**.
5. **Auto Scaling Groups** ensure that web servers scale dynamically.
6. Bastion hosts allow secure SSH access to private servers.

---

## 🛠 **Tech Stack & AWS Services Used**
✅ **Terraform** – Infrastructure as Code (IaC)  
✅ **AWS VPC** – Network Isolation  
✅ **Amazon EC2** – Compute resources  
✅ **Amazon RDS** – Relational Database Service  
✅ **Amazon EFS** – Shared File Storage  
✅ **AWS ALB** – Load Balancing Traffic  
✅ **Auto Scaling Groups** – Elastic Scaling  
✅ **NGINX** – Web Server  
✅ **AWS Route 53** – Domain Name System (DNS)  
✅ **AWS IAM** – Secure Access Management  

---

## 🔧 **Setup Instructions**
### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/saurabhshende13/AWS-Cloud-Infrastructure-Automation-using-Terraform.git
cd AWS-Cloud-Infrastructure-Automation-using-Terraform
```

### **2️⃣ Initialize Terraform**
```bash
terraform init
```

### **3️⃣ Plan the Deployment**
```bash
terraform plan
```

### **4️⃣ Apply the Configuration**
```bash
terraform apply -auto-approve
```

### **5️⃣ Access the Application**
- Find the **ALB DNS Name** from AWS Console.
- Open it in a browser:  
  ```
  http://<ALB-DNS-Name>
  ```

---

## 📌 **Conclusion**
This project automates the deployment of a **multi-tier AWS architecture** that is **highly scalable, secure, and cost-efficient** using **Terraform**. It follows best practices for security, networking, and high availability.  

---
