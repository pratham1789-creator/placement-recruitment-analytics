import csv
import random
import os
from datetime import date, timedelta

# Project paths

PROJECT_DIR = os.path.dirname(
    os.path.dirname(
        os.path.abspath(__file__)
    )
)

DATA_DIR = os.path.join(PROJECT_DIR, "data")

os.makedirs(DATA_DIR, exist_ok=True)

print("DATA FOLDER:", DATA_DIR)

# Project settings

random.seed(42)

NUM_CANDIDATES = 500
NUM_COMPANIES = 30
NUM_JOBS = 60
NUM_APPLICATIONS = 1500

START_DATE = date(2025, 1, 1)
END_DATE = date(2025, 12, 31)

# Candidate master data

first_names = [
    "Aarav", "Aditi", "Aditya", "Akash", "Aman",
    "Ananya", "Ankit", "Arjun", "Aryan", "Ayush",
    "Bhavya", "Chetan", "Deepak", "Diya", "Ishaan",
    "Isha", "Karan", "Kavya", "Khushi", "Manish",
    "Meera", "Mohit", "Naman", "Neha", "Nikhil",
    "Pooja", "Pranav", "Priya", "Rahul", "Riya",
    "Rohan", "Sakshi", "Sameer", "Shivam", "Shreya",
    "Sneha", "Sonia", "Tanvi", "Varun", "Vikas"
]

last_names = [
    "Sharma", "Verma", "Gupta", "Singh", "Kumar",
    "Patel", "Shah", "Mishra", "Dubey", "Joshi",
    "Mehta", "Kapoor", "Malhotra", "Chopra", "Agarwal",
    "Bansal", "Saxena", "Tiwari", "Pandey", "Rao"
]

locations = [
    "Delhi",
    "Gurgaon",
    "Noida",
    "Bangalore",
    "Mumbai",
    "Pune",
    "Hyderabad",
    "Chennai",
    "Kolkata",
    "Ahmedabad"
]

skills_list = [
    "SQL, Python, Excel",
    "SQL, Power BI, Excel",
    "Python, Pandas, SQL",
    "Java, SQL, Python",
    "Python, Tableau, SQL",
    "Excel, Power BI, SQL",
    "JavaScript, Python, SQL",
    "SQL, Statistics, Power BI",
    "Python, Machine Learning, SQL",
    "Excel, Tableau, Python"
]


# Generate candidates

candidates = []

for candidate_id in range(1, NUM_CANDIDATES + 1):

    first_name = random.choice(first_names)
    last_name = random.choice(last_names)

    name = f"{first_name} {last_name}"

    email = (
        f"{first_name.lower()}."
        f"{last_name.lower()}."
        f"{candidate_id}@example.com"
    )

    phone = f"9{random.randint(100000000, 999999999)}"

    candidate = {
        "candidate_id": candidate_id,
        "name": name,
        "email": email,
        "phone": phone,
        "location": random.choice(locations),
        "experience": random.randint(0, 8),
        "skills": random.choice(skills_list)
    }

    candidates.append(candidate)

    # Company master data

company_names = [
    "TechNova Solutions",
    "DataSphere Analytics",
    "FinEdge Technologies",
    "CloudMatrix Systems",
    "InsightWorks",
    "NextGen Digital",
    "BluePeak Technologies",
    "CodeCraft Solutions",
    "Vertex Analytics",
    "InnovateLabs",
    "BrightPath Systems",
    "CoreStack Technologies",
    "AlphaByte Solutions",
    "QuantumWorks",
    "Nexora Technologies",
    "DataBridge",
    "GrowthAxis",
    "SmartGrid Solutions",
    "LogicTree Systems",
    "Proxima Analytics",
    "CloudVista",
    "DigitalCore",
    "TechBridge",
    "ScalePoint",
    "DataOrbit",
    "FinTechWorks",
    "CodeVista",
    "Analytica Systems",
    "PrimeStack",
    "InsightEdge"
]


# Generate companies

companies = []

for company_id, company_name in enumerate(company_names, start=1):

    company = {
        "company_id": company_id,
        "company_name": company_name,
        "company_tier": random.choices(
            [1, 2, 3],
            weights=[20, 50, 30]
        )[0],
        "website": (
            f"https://www."
            f"{company_name.lower().replace(' ', '')}.com"
        ),
        "linkedin": (
            f"https://www.linkedin.com/company/"
            f"{company_name.lower().replace(' ', '-')}"
        ),
        "location": random.choice(locations)
    }

    companies.append(company)

    # Job master data

job_titles = [
    "Data Analyst",
    "Business Analyst",
    "Operations Analyst",
    "Data Scientist",
    "Business Intelligence Analyst",
    "Software Engineer",
    "Python Developer",
    "SQL Developer",
    "Product Analyst",
    "Reporting Analyst"
]

job_types = [
    "Full-time",
    "Full-time",
    "Full-time",
    "Internship",
    "Contract"
]


# Generate jobs

jobs = []

for job_id in range(1, NUM_JOBS + 1):

    company = random.choice(companies)

    job = {
        "job_id": job_id,
        "company_id": company["company_id"],
        "job_title": random.choice(job_titles),
        "job_type": random.choice(job_types),
        "location": random.choice(locations),
        "exp_required": random.randint(0, 5)
    }

    jobs.append(job)

    # Application data

applications = []

# Keep track of candidate-job combinations
# so the same candidate doesn't apply to the same job twice.
used_combinations = set()

application_id = 1


while len(applications) < NUM_APPLICATIONS:

    candidate = random.choice(candidates)
    job = random.choice(jobs)

    combination = (
        candidate["candidate_id"],
        job["job_id"]
    )

    # Skip if this candidate already applied to this job
    if combination in used_combinations:
        continue

    used_combinations.add(combination)

    applied_date = START_DATE + timedelta(
        days=random.randint(
            0,
            (END_DATE - START_DATE).days
        )
    )

    application = {
        "application_id": application_id,
        "candidate_id": candidate["candidate_id"],
        "job_id": job["job_id"],
        "applied_date": applied_date
    }

    applications.append(application)

    application_id += 1

    # Recruitment stage history

application_stages = []

stage_record_id = 1

# Stage probabilities
# Each value represents the probability of reaching that stage.

stage_probabilities = [
    (2, 0.78),  # Screening
    (3, 0.62),  # Technical Round 1
    (4, 0.48),  # Technical Round 2
    (5, 0.36),  # Assignment
    (6, 0.25)   # Selection
]


for application in applications:

    current_date = application["applied_date"]

    # Every application starts at Applied
    application_stages.append({
        "stage_record_id": stage_record_id,
        "application_id": application["application_id"],
        "stage_id": 1,
        "stage_date": current_date,
        "result": "Passed"
    })

    stage_record_id += 1

    # Move through the recruitment funnel
    for stage_id, probability in stage_probabilities:

        # Candidate fails to reach this stage
        if random.random() > probability:

            current_date += timedelta(
                days=random.randint(1, 7)
            )

            application_stages.append({
                "stage_record_id": stage_record_id,
                "application_id": application["application_id"],
                "stage_id": stage_id,
                "stage_date": current_date,
                "result": "Rejected"
            })

            stage_record_id += 1

            # Stop this application here
            break

        # Candidate reaches the stage
        current_date += timedelta(
            days=random.randint(2, 10)
        )

        result = "Selected" if stage_id == 6 else "Passed"

        application_stages.append({
            "stage_record_id": stage_record_id,
            "application_id": application["application_id"],
            "stage_id": stage_id,
            "stage_date": current_date,
            "result": result
        })

        stage_record_id += 1


        # Create the data folder

os.makedirs("data", exist_ok=True)

# Function to write data into CSV files

def write_csv(filename, fieldnames, rows):

    with open(filename, "w", newline="", encoding="utf-8") as file:

        writer = csv.DictWriter(
            file,
            fieldnames=fieldnames
        )

        writer.writeheader()
        writer.writerows(rows)

write_csv(
    "data/candidates.csv",

    [
        "candidate_id",
        "name",
        "email",
        "phone",
        "location",
        "experience",
        "skills"
    ],

    candidates
)

write_csv(
    "data/companies.csv",

    [
        "company_id",
        "company_name",
        "company_tier",
        "website",
        "linkedin",
        "location"
    ],

    companies
)

write_csv(
    "data/jobs.csv",

    [
        "job_id",
        "company_id",
        "job_title",
        "job_type",
        "location",
        "exp_required"
    ],

    jobs
)

write_csv(
    "data/applications.csv",

    [
        "application_id",
        "candidate_id",
        "job_id",
        "applied_date"
    ],

    applications
)

write_csv(
    "data/application_stages.csv",

    [
        "stage_record_id",
        "application_id",
        "stage_id",
        "stage_date",
        "result"
    ],

    application_stages
)

        # Basic validation

print("\nDATA GENERATION COMPLETE")
print("-" * 40)

print(f"Candidates:         {len(candidates)}")
print(f"Companies:          {len(companies)}")
print(f"Jobs:               {len(jobs)}")
print(f"Applications:       {len(applications)}")
print(f"Application Stages: {len(application_stages)}")

print("-" * 40)
print("CSV files created inside data/")