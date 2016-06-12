module API::Helpers::RenderHelper
  def success!(resource, status=200, status_code="success", opts={})
    content_type("application/json")
    Rails.logger.info "[api-complete] Requested: #{simple_log_data}"
    { code:   status,
      status: status_code,
      data:   resource
    }.merge(opts).delete_if{ |k,v| v.blank? && !v.is_a?(Array) }
  end

  def simple_log_data
    {
        method: env['REQUEST_METHOD'],
        path:   env['PATH_INFO'],
        ip:     env['REMOTE_ADDR'],
        query:  env['QUERY_STRING']
    }.to_s.encode('UTF-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
  end

  def download!(resource,status=200,status_code='success')
    content_type 'application/octet-stream'
    body resource
  end

  def error_500!(msg)
    throw_error!(500, 'InternalServerError', msg)
  end

  def error_404!(msg)
    throw_error!(404, 'RecordNotFoundError', msg)
  end

  def error_403!(msg)
    throw_error!(403, 'RecordInvalidError', msg)
  end

  def error_422!(msg)
    throw_error!(422, 'UnprocessableEntityError', msg)
  end

  def error_401!(msg)
    throw_error!(401, 'NotAuthorizedError', msg)
  end

  def after_save(obj, status, msg, template=:basic)
    if obj.errors.any?
      error_422!(obj.as_api_response(:errors))
    else
      success!(obj.as_api_response(template), status, "saved", {message: msg})
    end
  end

  def throw_error!(code, status, msg)
    content_type("application/json")
    default_object = {code: code, status: status}
    Rails.logger.info "[api-complete] Requested Error: #{simple_log_data} | Errors: #{msg}"
    if msg.is_a?(Hash) && msg[:errors].present?
      error!(default_object.merge(error: msg[:errors].join(',')), code)
    elsif msg.is_a?(Array)
      error!(default_object.merge(error: msg.join(',')), code)
    else
      error!(default_object.merge(error: msg), code)
    end

  end
end
