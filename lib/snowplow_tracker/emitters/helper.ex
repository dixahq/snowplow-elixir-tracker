defmodule SnowplowTracker.Emitters.Helper do
  @moduledoc """
  This module contains helper functions to format and sanitize the data
  necessary for the emitter module
  """

  alias SnowplowTracker.{Constants, Payload}

  @get_method "GET"
  @post_method "POST"
  @get_path Constants.get_protocol_path()
  @post_vendor Constants.post_protocol_vendor()
  @post_version Constants.post_protocol_version()

  # Public API

  @doc """
  This function is used to generate the endpoint with the query parameters
  which are used to send events to the collector.
  """
  @spec generate_endpoint(String.t(), String.t(), String.t(), Payload.t(), String.t()) ::
          String.t()
  def generate_endpoint(protocol, uri, nil = _port, payload, request_method) do
    do_generate_endpoint(
      protocol,
      uri,
      "",
      payload,
      request_method
    )
  end

  def generate_endpoint(protocol, uri, port, payload, request_method) do
    do_generate_endpoint(
      protocol,
      uri,
      ":#{port}",
      payload,
      request_method
    )
  end

  # Private API

  @doc false
  defp do_generate_endpoint(protocol, uri, port, payload, @get_method) do
    params = URI.encode_query(payload)
    "#{protocol}://#{uri}#{port}/#{@get_path}?#{params}"
  end

  defp do_generate_endpoint(protocol, uri, port, _payload, @post_method) do
    "#{protocol}://#{uri}#{port}/#{@post_vendor}/#{@post_version}"
  end
end
