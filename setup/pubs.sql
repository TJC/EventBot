--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: pubs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eventbot
--

SELECT pg_catalog.setval('pubs_id_seq', 76, true);


--
-- Data for Name: pubs; Type: TABLE DATA; Schema: public; Owner: eventbot
--

INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (1, 'Angelic', '57 Liverpool Road, London, N1 0RJ', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/3197', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (2, 'As Good As It Gets', '125 Packington Street, London, N1 7EA', 'Islington', 'http://www.fancyapint.com/main_site/thepubs/pub2273.htm', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (3, 'Ben Crouch''s Tavern', '77a Wells Street, London, W1P 3RE', 'Fitzrovia', 'http://www.beerintheevening.com/pubs/show.shtml/2115', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (4, 'Big Red', '385 Holloway Road, London, N7 0RY', 'Holloway', 'http://www.beerintheevening.com/pubs/show.shtml/21857', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (5, 'Doggett''s Coat and Badge', '1 Blackfriars Bridge, London, SE1 9UD', 'Southwark', 'http://www.beerintheevening.com/pubs/show.shtml/2517', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (6, 'Garlic and Shots', '14 Frith Street, London, W1V 5TS', 'Soho', 'http://www.beerintheevening.com/pubs/show.shtml/4277', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (7, 'Hardys Freehouse', '92 Trafalgar Road, Greenwich, London, SE10 9UW', 'Greenwich', 'http://www.beerintheevening.com/pubs/show.shtml/1199', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (8, 'Inc Bar', '7a College Approach, Greenwich, London, SE10 9HY', 'Greenwich', 'http://www.beerintheevening.com/pubs/show.shtml/7893', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (9, 'Quinn''s', '65 Kentish Town Road, London, NW1 8NY', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/2555', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (10, 'Richard I', '52 Royal Hill, Greenwich, London, SE10 8RT', 'Greenwich', 'http://www.beerintheevening.com/pubs/show.shtml/1202', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (11, 'Rosie McCann''s', '244 York Way, London, N7 9AG', 'Kings Cross', 'http://www.beerintheevening.com/pubs/show.shtml/18707', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (12, 'Shillibeers Brasserie Bar', '1 Carpenters Mews, North Road, London, N7 9EF', 'Holloway', 'http://www.beerintheevening.com/pubs/show.shtml/5204', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (13, 'Shish', '313-319 Old Street, London, EC1V 9LE', 'Old Street', 'http://www.shish.com/restaurants/', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (15, 'The Albion', '10 Thornhill Road, Barnsbury, London, N1 1HW', 'Barnsbury', 'http://www.beerintheevening.com/pubs/show.shtml/3942', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (16, 'The Alwyne Castle', '83 St Paul''s Road, London, N1 2LY', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/1350', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (17, 'The Anchor', '34 Park Street, Bankside, Southwark, London, SE1 9EF', 'Southwark', 'http://www.beerintheevening.com/pubs/show.shtml/1638', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (18, 'The Banker', 'Cousin Lane, London, EC4R 3TE', 'Cannon Street', 'http://www.beerintheevening.com/pubs/show.shtml/12970', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (19, 'The Bell, Book and Candle', '42 Ludgate Hill, London, EC4M 7DE', 'St Paul''s', 'http://www.beerintheevening.com/pubs/show.shtml/7356', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (20, 'The Blackfriar', '174 Queen Victoria Street, London, EC4V 4EG', 'Blackfriars', 'http://www.beerintheevening.com/pubs/show.shtml/602', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (21, 'The Bricklayers Arms', '31 Gresse Street, London, W1T 1QS', 'Fitzrovia', 'http://www.beerintheevening.com/pubs/show.shtml/880', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (22, 'The Camden Tup', '2-3 Greenland Place, London, NW1 0AP', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/3013', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (23, 'The Captain Kidd', '108 Wapping High Street, London, E1W 2NE', 'Wapping', 'http://www.beerintheevening.com/pubs/show.shtml/4000', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (24, 'The Cittie of Yorke', '22 High Holborn, London, WC1V 6BS', 'Holborn', 'http://www.beerintheevening.com/pubs/show.shtml/446', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (25, 'The City Retreat', '74 Shoe Lane, London, EC4 3BQ', 'Holborn', 'http://www.beerintheevening.com/pubs/show.shtml/11686', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (26, 'The Constitution', '42 St Pancras Way, London, NW1 0QT', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/6570', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (27, 'The Coronet', '338-346 Holloway Road, London, N7 6PA', 'Holloway', 'http://www.beerintheevening.com/pubs/show.shtml/6320', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (28, 'The Cutty Sark Tavern', '4-7 Ballast Quay, Greenwich, London, SE10 9PD', 'Greenwich', 'http://www.beerintheevening.com/pubs/show.shtml/1197', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (29, 'The Dartmouth Arms', '35 York Rise, Tufnell Park, London, NW5 1SP', 'Dartmouth Park', 'http://www.beerintheevening.com/pubs/show.shtml/1323', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (30, 'The Devonshire Arms', '33 Kentish Town Road, London, NW1 8NL', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/1294', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (31, 'The Doric Arch', '1 Eversholt Street, Euston, London, NW1 1DN', 'Euston', 'http://www.beerintheevening.com/pubs/show.shtml/122', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (32, 'The Driver', '2-4 Wharfdale Road, London N1 9RY', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/28304', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (33, 'The Eagle', '159 Farringdon Road, London, EC1R 3AL', 'Clerkenwell', 'http://www.beerintheevening.com/pubs/show.shtml/8247', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (34, 'The Edinboro Castle', '57 Mornington Terrace, London, NW1 7RU', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/1009', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (35, 'The Enterprise', '2 Haverstock Hill, Camden, London, NW3 2BL', 'Chalk Farm', 'http://www.beerintheevening.com/pubs/show.shtml/1764', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (36, 'The Flask', '77 Highgate West Hill, London, N6 6BU', 'Highgate', 'http://www.beerintheevening.com/pubs/show.shtml/5199', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (37, 'The Foundry', '84-86 Great Eastern Street, London, EC2A 3JL', 'Shoreditch', 'http://www.beerintheevening.com/pubs/show.shtml/3000', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (38, 'The George', '77 Borough High Street, London, SE1 1NH', 'London Bridge', 'http://www.beerintheevening.com/pubs/show.shtml/434', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (39, 'The Golden Fleece', '8-9 Queen Street, London, EC4N 1SP', 'Bank', 'http://www.beerintheevening.com/pubs/show.shtml/2448', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (40, 'The Grafton Arms', '20 Prince of Wales Road, London, NW5 3LG', 'Kentish Town', 'http://www.beerintheevening.com/pubs/show.shtml/6535', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (41, 'The Green Man', '36 Riding House Street, London, W1W 7ES', 'Fitzrovia', 'http://www.beerintheevening.com/pubs/show.shtml/2177', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (42, 'The Greenwich Union', '56 Royal Hill, Greenwich, London, SE10 8RT', 'Greenwich', 'http://www.beerintheevening.com/pubs/show.shtml/1203', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (43, 'The Hill', '94 Haverstock Hill, London, NW3 2BD', 'Hampstead', 'http://www.worldsbestbars.com/city/london/the-hill-london.htm', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (44, 'The Hope and Anchor', '207 Upper Street, Islington, London, N1 1RL', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/87', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (45, 'The Intrepid Fox', '15 St Giles High Street, London, WC2H 8LN', 'Soho', 'http://www.beerintheevening.com/pubs/show.shtml/3517', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (46, 'The Jack Horner', '234 Tottenham Court Road, London, W1T 7QJ', 'Tottenham Court Road', 'http://www.beerintheevening.com/pubs/show.shtml/4378', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (47, 'The Landseer', '37 Landseer Road, London, N19 4JU', 'Holloway', 'http://www.beerintheevening.com/pubs/show.shtml/2297', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (48, 'The Lark in the Park', '60 Copenhagen Street, London, N1 0JW', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/7737', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (49, 'The Lock Tavern', '35 Chalk Farm Road, London, NW1 8AJ', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/1086', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (50, 'The London Stone', '109 Cannon Street, London, EC4N 5AD', 'Cannon Street', 'http://www.beerintheevening.com/pubs/show.shtml/7548', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (51, 'The Lord Raglan', '61 St Martin''s Le Grand, London, EC1A 4ER', 'St Paul''s', 'http://www.beerintheevening.com/pubs/show.shtml/3553', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (14, 'The Abbey', '124 Kentish Town Road, London, NW1 9QB', 'Kentish Town', 'http://www.beerintheevening.com/pubs/show.shtml/12080', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (52, 'The Lord Stanley', '51 Camden Park Road, London, NW1 9BH', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/1463', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (53, 'The Marlborough Head', '24 North Audley Street, London, W1K 6WB', 'Marble Arch', 'http://www.beerintheevening.com/pubs/show.shtml/1735', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (54, 'The Old King''s Head', '382 Holloway Road, London, N7 6PN', 'Holloway', 'http://www.camranorthlondon.org.uk/nlpg/n7.html#old_kings_head_n7', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (55, 'The Old Thameside Inn', 'Pickfords Wharf, Clink Street, London, SE1 9DG', 'London Bridge', 'http://www.beerintheevening.com/pubs/show.shtml/432', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (57, 'The Penderel''s Oak', '283-288 High Holborn, London, WC1V 7HP', 'Holborn', 'http://www.beerintheevening.com/pubs/show.shtml/59', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (58, 'The Porterhouse', '21-22 Maiden Lane, London, WC2E 7NA', 'Covent Garden', 'http://www.beerintheevening.com/pubs/show.shtml/366', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (59, 'The Princess Louise', '208-209 High Holborn, London, WC1V 7BW', 'Holborn', 'http://www.beerintheevening.com/pubs/show.shtml/194', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (60, 'The Prospect of Whitby', '57 Wapping Wall, London, E1W 3SH', 'Shadwell', 'http://www.beerintheevening.com/pubs/show.shtml/2278', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (61, 'The Purple Turtle', '65 Crowndale Road, London, NW1 1TN', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/1283', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (62, 'The Rat and Parrot', '25 Parkway, London, NW1 7PG', 'Camden', 'http://www.beerintheevening.com/pubs/show.shtml/7717', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (63, 'The Royal Oak', '44 Tabard Street, London, SE1 4JU', 'Borough', 'http://www.beerintheevening.com/pubs/show.shtml/2814', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (64, 'The Salisbury Hotel', '1 Grand Parade, Finsbury Park, London, N4 1JX', 'Harringay', 'http://www.fancyapint.com/main_site/thepubs/pub2053.html', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (65, 'The Shakespeare', '2 Goswell Road, Clerkenwell, London, EC1M 7AA', 'Clerkenwell', 'http://www.beerintheevening.com/pubs/show.shtml/7338', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (66, 'The Ship', '116 Wardour Street, London, W1F 0TT', 'Soho', 'http://www.beerintheevening.com/pubs/show.shtml/749', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (67, 'The Ship Tavern', '12 Gate Street, London, WC2A 3HP', 'Holborn', 'http://www.beerintheevening.com/pubs/show.shtml/763', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (68, 'The Wellington', '119 Balls Pond Road, London, N1 4BL', 'Kingsland', 'http://www.beerintheevening.com/pubs/show.shtml/1730', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (69, 'The Wenlock Arms', '26 Wenlock Road, London, N1 7TA', 'Wenlock', 'http://www.beerintheevening.com/pubs/show.shtml/1316', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (70, 'The Woolpack', '98 Bermondsey Street, London, SE1 3UB', 'London Bridge', 'http://www.beerintheevening.com/pubs/show.shtml/1509', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (71, 'Ye Olde Cheshire Cheese', 'Wine Office Court, 145 Fleet Street, London, EC4A 2BU', 'Fleet Street', 'http://www.beerintheevening.com/pubs/show.shtml/1513', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (72, 'Ye Olde White Horse', '2 St Clements Lane, London, WC2A 2HA', 'Aldwych', 'http://www.beerintheevening.com/pubs/show.shtml/1107', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (73, 'None of the Above', 'To be specified manually', 'Anywhere', NULL, false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (74, 'The Mucky Pup', '39 Queens Head Street', 'Islington', 'http://www.beerintheevening.com/pubs/s/51/5169/Mucky_Pup/Angel_Islington', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (56, 'The Orwell', '382 Essex Road, Islington, London, N1 3PF', 'Islington', 'http://www.beerintheevening.com/pubs/show.shtml/26350', false);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (75, 'The Shaftesbury', '534 Hornsey Road, London, N19 3QN', 'Holloway', 'http://www.beerintheevening.com/pubs/s/15/15722/Shaftesbury/Holloway', true);
INSERT INTO pubs (id, name, street_address, region, info_uri, endorsed) VALUES (76, 'The Faltering Fullback', '19 Perth Road, London, N4 3HB', 'Finsbury Park', 'http://www.beerintheevening.com/pubs/s/15/1539/Faltering_Fullback/Finsbury_Park', true);


--
-- PostgreSQL database dump complete
--

