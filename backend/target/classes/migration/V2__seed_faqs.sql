INSERT INTO knowledge_base (category, question, answer, keywords) VALUES
('Admissions', 'How do I apply to GSU?', 'Apply online via the GSU Admissions Portal. Prepare academic transcripts, certified ID, and application fee proof.', 'admissions,apply,application,portal'),
('Fees', 'What are the current tuition fees?', 'Tuition varies by programme. Check the fees schedule on the Finance page or contact the Bursar''s office.', 'fees,tuition,bursar,payment'),
('Programmes', 'Which programmes are offered?', 'GSU offers undergraduate and postgraduate programmes in Mining, Engineering, Agriculture, Earth Sciences, and more.', 'programmes,courses,departments,undergraduate,postgraduate')
ON CONFLICT DO NOTHING;
