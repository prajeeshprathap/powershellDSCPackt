using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Wonders.Api.Data;
using Wonders.Api.Models;

namespace Wonders.Api.Controllers
{
    public class WondersController : ApiController
    {
        [HttpGet]
        [Route("api/wonders")]
        public HttpResponseMessage All()
        {
            return Request.CreateResponse(HttpStatusCode.OK, WonderFactory.All());
        }

        [HttpGet]
        [Route("api/wonders/{name}")]
        public HttpResponseMessage One(string name)
        {
            var wonder = WonderFactory.All().FirstOrDefault(w => string.CompareOrdinal(w.Name, name) == 0);
            return wonder != default(Wonder)
                ? Request.CreateResponse(HttpStatusCode.OK, wonder)
                : Request.CreateErrorResponse(HttpStatusCode.NoContent, $"Failed to find a wonder with name {name}");
        }
    }
}