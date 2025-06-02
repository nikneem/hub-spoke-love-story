using Azure;
using Azure.Data.Tables;

namespace Demo.WebApi.Entities
{
    public class ConferenceTableEntity: ITableEntity
    {
        public string PartitionKey { get; set; }
        public string RowKey { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public DateTimeOffset? Timestamp { get; set; }
        public ETag ETag { get; set; }
    }
}
