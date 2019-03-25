# Autospotting Helm Chart


## Chart Details
This chart will do the following:
* Implement autospotting, a tool to automatically convert your existing autoscaling groups to cheaper spot instances with minimal config chanages.  The source code for autospotting is available at [AutoSpotting](https://github.com/AutoSpotting/AutoSpotting).

## Configuration
| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `image`                 | uri to pull the image from            | `quay.io/reactiveops/autospotting` |
| `schedule`              | cron schedule the job will run with   | `*/5 * * * *`                                              |
| `resources.cpu`         | cpu millicores to request             | `30m`                                                    |
| `resources.mem`         | amount of physical mem to request     | `30Mi`|
| `environment`           | Map of environment settings. | See the table of default values below. |

`environment` map default values:

| Parameter               | Description                           | Default                                                    |
| ----------------------- | ----------------------------------    | ---------------------------------------------------------- |
| `REGIONS` | Comma separated string of regions where it should be activated.  Set it to blank to run in all regions. | `us*` |
| `ALLOWED_INSTANCE_TYPES` | if specified, spot instances will be of these types.  If blank, type is autodetected form each ASG based on it's launch configuration.  Accepts a string of comma separated instance types e.g. 'c5.*,c4.xlarge' | `r4.*` |
| `DISALLOWED_INSTANCE_TYPES` | If specified, the spot instances will _never_ be of these types.  Accepts a string of comma separated instance types (supports globs). |  |
| `ON_DEMAND_PRICE_MULTIPLIER` | Multiplier for the on-demand price. This is useful for volume discounts or if you want to set your bid price to be higher than the on demand price to reduce the chances that your spot instances will be terminated. | `1` |
| `BIDDING_POLICY` | Policy choice for spot bid. If set to 'normal', we bid at the on-demand price.  If set to 'aggressive', we bid at a percentage value above the spot price configurable using the spot_price_buffer_percentage. | `normal` |
| `MIN_ON_DEMAND_NUMBER` | On-demand capacity (as absolute number) ensured to be running in each of your groups.  Can be overridden on a per-group basis using the tag autospotting_min_on_demand_number. | `0` |
| `MIN_ON_DEMAND_PERCENTAGE` | On-demand capacity (percentage of the total number of instances in the group) ensured to be running in each of your groups.  Can be overridden on a per-group basis using the tag autospotting_min_on_demand_percentage It is ignored if min_on_demand_number is also set. | `0` |
| `ON_DEMAND_PRICE_MULTIPLIER` | Multiplier for the on-demand price. This is useful for volume discounts or if you want to set your bid price to be higher than the on demand price to reduce the chances that your spot instances will be terminated. | `1` |
| `SPOT_PRICE_BUFFER_PERCENTAGE` | Percentage Value of the bid above the current spot price. A spot bid would be placed at a value current_spot_price * [1 + (spot_price_buffer_percentage/100.0)]. The main benefit is that it protects the group from running spot instances that got significantly more expensive than when they were initially launched, but still somewhat less than the on-demand price. Can be enforced using the tag: autospotting_spot_price_buffer_percentage. If the bid exceeds the on-demand price, we place a bid at on-demand price itself. | `10` |
| `SPOT_PRODUCT_DESCRIPTION` | The Spot Product or operating system to use when looking up spot price history in the market. Valid choices: Linux/UNIX, SUSE Linux, Windows, Linux/UNIX (Amazon VPC), SUSE Linux (Amazon VPC), Windows (Amazon VPC) | `Linux/UNIX (Amazon VPC)` |
| `TAG_FILTERS` | List of map tags to filter the ASGs on, formatted as a string. | `[{spot-enabled true}]` |
| `AWS_ACCESS_KEY_ID` | aws access key id | |
| `AWS_SECRET_ACCESS_KEY` | aws secret key | |
| ` AWS_SESSION_TOKEN` | aws token | |

### Example Autohelm configuration
```yaml
charts:
  autospotting:
    repository:
      git: https://github.com/reactiveops/autospotting-ci.git
    chart: chart
    namespace: default
    values:
      image: quay.io/reactiveops/autospotting:0.1.3
      environment:
        REGIONS: "*"
        ALLOWED_INSTANCE_TYPES: "*"
```
