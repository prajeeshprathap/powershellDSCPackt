using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Wonders.Api.Models;

namespace Wonders.Api.Data
{
    public class WonderFactory
    {
        private static List<Wonder> _wonders = new List<Wonder>
            {
                new Wonder
                {
                    Name = "Great pyramid of Giza",
                    Description = "The oldest and largest of the three pyramids in the Giza pyramid complex bordering what is now El Giza, Egypt",
                    Country = "Egypt"
                },
                new Wonder
                {
                    Name = "Great wall of China",
                    Description = "Series of fortifications made of stone, brick, tamped earth, wood, and other materials",
                    Country = "China"
                },
                new Wonder
                {
                    Name = "Petra",
                    Description = "Historical and archaeological city in southern Jordan",
                    Country = "Jordan"
                },
                new Wonder
                {
                    Name = "The Colosseum in Rome",
                    Description = "An oval amphitheatre in the centre of the city of Rome, Italy",
                    Country = "Italy"
                },
                new Wonder
                {
                    Name = "Chichen Itza",
                    Description = "Large pre-Columbian city built by the Maya people of the Terminal Classic period",
                    Country = "Mexico"
                },
                new Wonder
                {
                    Name = "Machu Picchu",
                    Description = "15th-century Inca citadel situated on a mountain ridge 2,430 metres (7,970 ft) above sea level",
                    Country = "Peru"
                },
                new Wonder
                {
                    Name = "Taj Mahal",
                    Description = "Ivory-white marble mausoleum on the south bank of the Yamuna river in the Indian city of Agra",
                    Country = "India"
                },
                new Wonder
                {
                    Name = "Christ the Redeemer",
                    Description = "Art Deco statue of Jesus Christ in Rio de Janeiro, Brazil",
                    Country = "Brazil"
                }
            };
        public static IList<Wonder> All()
        {
            return _wonders;
        }
    }
}