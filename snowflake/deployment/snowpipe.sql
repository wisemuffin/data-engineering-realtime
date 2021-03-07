
/*
1) create storage integration
2) create stage
3) create target table
4) create pipe
5) create role for user to use pipe
6) get pipe sns arn

https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-s3.html
*/

create storage integration s3_int
  type = external_stage
  storage_provider = s3
  enabled = true
  storage_aws_role_arn = 'arn:aws:iam::<accountnumber>:role/mysnowflakerole'
  storage_allowed_locations = ('s3://kafka-to-s3-to-snowflake/')
  ;
  
  DESC INTEGRATION s3_int;
  

create or replace stage snowpipeexample_stage
  url = 's3://kafka-to-s3-to-snowflake/topics/first_topic/'
  storage_integration = s3_int;
  
create or replace table snowpipeexample_t (
    src variant
)

;

 ;
 create pipe public.snowpipeexample_pipe auto_ingest=true as
  copy into public.snowpipeexample_t
  from @public.snowpipeexample_stage
  file_format = (type = 'JSON');
  
  ;
  drop pipe public.snowpipeexample_pipe 
  ;
  
  
-- Create a role to contain the Snowpipe privileges
use role securityadmin;

create or replace role snowpipeexample;

-- Grant the required privileges on the database objects
grant usage on database snowpipe_example to role snowpipeexample;

grant usage on schema snowpipe_example.public to role snowpipeexample;

grant insert, select on snowpipe_example.public.snowpipeexample_t to role snowpipeexample;

grant usage on stage snowpipe_example.public.snowpipeexample_stage to role snowpipeexample;

-- Grant the OWNERSHIP privilege on the pipe object
ALTER PIPE SNOWPIPEEXAMPLE_PIPE SET PIPE_EXECUTION_PAUSED=true;
grant ownership on pipe snowpipe_example.public.snowpipeexample_pipe to role snowpipeexample;

-- Grant the role to a user
grant role snowpipeexample to user wisemuffin;

-- Set the role as the default role for the user
alter user wisemuffin set default_role = snowpipeexample;




/*
TEST data in table
*/
show pipes;

select *
from "SNOWPIPE_EXAMPLE"."PUBLIC"."SNOWPIPEEXAMPLE_T"
;

/*
debug

notifations reachin sqs but pipe not sending to table. likley table header vs json

need to create a file format of json in db
*/
grant ownership on pipe snowpipe_example.public.snowpipeexample_pipe to role accountadmin;
;
select SYSTEM$PIPE_STATUS('snowpipeexample_pipe')
;
select SYSTEM$PIPE_FORCE_RESUME('SNOWPIPEEXAMPLE_PIPE');
ALTER PIPE SNOWPIPEEXAMPLE_PIPE SET PIPE_EXECUTION_PAUSED=false;