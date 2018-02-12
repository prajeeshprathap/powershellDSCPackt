using System;
using System.Web.Http;

namespace Wonders.Api.Controllers
{
    public class HomeController : ApiController
    {
        [Route("")]
        [HttpGet]
        public IHttpActionResult Index()
        {
            var swaggerUrl = new Uri("swagger", UriKind.Relative);
            return Redirect(swaggerUrl);
        }
    }
}
