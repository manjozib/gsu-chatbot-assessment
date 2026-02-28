INSERT INTO knowledge_base (category, question, answer, keywords) VALUES
-- Admissions & Registration
('Admissions', 'What are the minimum entry requirements?',
 'Minimum entry requirements differ per programme, but generally include at least 5 O-Level passes including English and Maths, plus A-Level passes relevant to your field of study.',
 'entry requirements,admissions,olevel,alevel,requirements'),

('Admissions', 'Does GSU accept online applications?',
 'Yes, GSU accepts online applications through the official Admissions Portal. Upload all required documents and proof of payment.',
 'admissions,online application,portal,apply'),

('Admissions', 'Can I apply for multiple programmes?',
 'Yes, applicants may choose up to two programmes when submitting an application.',
 'admissions,multiple programmes,choices'),

-- Fees & Payments
('Fees', 'How do I pay tuition fees?',
 'Fees can be paid via bank transfer, mobile money platforms, or directly at the university finance office.',
 'fees,payment methods,finance,banking,mobile money'),

('Fees', 'Does GSU offer payment plans?',
 'Yes, students may arrange payment plans with the Finance Office depending on their financial situation.',
 'fees,payment plans,installments,finance'),

-- Accommodation
('Accommodation', 'Does GSU provide student accommodation?',
 'Yes, limited on-campus accommodation is available. Priority is given to first-year students and those with special needs.',
 'accommodation,hostel,rooms,residence'),

('Accommodation', 'How do I apply for accommodation?',
 'Accommodation applications are submitted through the Student Affairs Office after registration.',
 'accommodation,apply hostel,student affairs'),

-- Programmes
('Programmes', 'What engineering programmes does GSU offer?',
 'GSU offers programmes such as Mining Engineering, Metallurgy, Geomatics, and other science and technology degrees.',
 'programmes,engineering,mining,metallurgy,geomatics'),

('Programmes', 'Are part-time or block-release programmes available?',
 'Yes, GSU offers both part-time and block-release options for selected programmes.',
 'block release,part time,programmes,flexible learning'),

-- ICT Support
('ICT', 'How do I reset my university email password?',
 'You can reset your university email password by visiting the ICT Helpdesk or using the self-service password reset portal.',
 'ict,email reset,password reset,helpdesk'),

('ICT', 'Wi-Fi is not working. What should I do?',
 'Restart your device, forget and rejoin the GSU Wi-Fi network, or contact ICT for troubleshooting.',
 'wifi,network problem,internet,ict'),

-- Registration & Academics
('Registration', 'How do I register for my courses?',
 'Course registration is done online via the Student Portal. Consult your department for guidance before selecting modules.',
 'registration,modules,student portal'),

('Registration', 'What should I do if I fail a module?',
 'If you fail a module, consult your department for supplementary, repeat, or remediation options.',
 'failed module,repeat module,supplementary'),

-- General
('General', 'Where is Gwanda State University located?',
 'GSU is located in Filabusi, Matabeleland South Province, Zimbabwe.',
 'location,address,where is gsu'),

('General', 'How can I contact the university?',
 'You can contact GSU via the university website, phone, or visit the administration offices during working hours.',
 'contact,phone,email,help')
    ON CONFLICT DO NOTHING;