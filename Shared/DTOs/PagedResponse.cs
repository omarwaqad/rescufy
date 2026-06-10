using System.Collections.Generic;

namespace Shared.DTOs
{
    public class PagedResponse<T>
    {
        public IEnumerable<T> Data { get; set; } = new List<T>();
        public PaginationMeta Meta { get; set; } = new PaginationMeta();
    }

    public class PaginationMeta
    {
        public int Page { get; set; }
        public int Limit { get; set; }
        public int TotalPages { get; set; }
        public int TotalItems { get; set; }
    }
}
