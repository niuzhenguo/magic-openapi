# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Api
  attr_reader :uri

  def initialize(api, uri)
    @api = api
    # remove '\'
    uri[0] = ''
    @uri = uri
  end

  def get_resource_name
    req_body = @api['post'].body_schema
    if req_body.include? 'x-resource'
      req_body['x-resource']
    else
      ''
    end
  end

  def get_description
    raw = @api['post'].raw
    if raw.include? 'description'
      raw['description']
    else
      ''
    end
  end

  def get_properties
    resp_body = @api['get'].response_body_schema(200)
    resp_body['properties']
  end

  def get_required
    req_body = @api['post'].body_schema
    if req_body.include? 'required'
      req_body['required']
    else
      []
    end
  end

  def get_output
    req_body = @api['post'].body_schema
    resp_body = @api['get'].response_body_schema(200)
    output = []
    resp_body['properties'].each do |key, value|
      if not req_body['properties'].include?(key)
        output.push(key)
      end
    end
    output
  end

  def get_parameters
    req_body = @api['post'].body_schema
    resp_body = @api['get'].response_body_schema(200)
    parameters = Hash.new
    req_body['properties'].each do |key, value|
      if not resp_body['properties'].include?(key)
        parameters[key] = value
      end
    end
    parameters
  end

end
