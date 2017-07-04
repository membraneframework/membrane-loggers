use Mix.Config

config :membrane_loggers, :bundlex_lib,
  macosx: [
    nif: [
      membrane_loggers_console: [
        includes: [
          "../membrane_common_c/c_src",
          "./deps/membrane_common_c/c_src",
        ],
        sources: [
          "console.c",
        ],
      ],
    ]
  ],
  windows32: [
    nif: [
      membrane_loggers_console: [
        includes: [
          "../membrane_common_c/c_src",
          "./deps/membrane_common_c/c_src",
        ],
        sources: [
          "console.c",
        ],
      ],
    ]
  ],
  windows64: [
    nif: [
      membrane_loggers_console: [
        includes: [
          "../membrane_common_c/c_src",
          "./deps/membrane_common_c/c_src",
        ],
        sources: [
          "console.c",
        ],
      ],
    ]
  ],
  linux: [
    nif: [
      membrane_loggers_console: [
        includes: [
          "../membrane_common_c/c_src",
          "./deps/membrane_common_c/c_src",
        ],
        sources: [
          "console.c",
        ],
      ],
    ]
]
