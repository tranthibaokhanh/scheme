test = {
  'names': [
    'q15A',
    'Q15A',
    'qA15',
    'QA15',
    'A15',
    '15A',
    '15'
  ],
  'points': 1,
  'suites': [
    [
      {
        'never_lock': True,
        'test': r"""
        >>> eval('''
        ... (cond ((> 2 3) 5)
        ...    ((> 2 4) 6)
        ...    ((< 2 5) 7)
        ...    (else 8))
        ... ''')
        7
        >>> eval('''
        ... (cond ((> 2 3) 5)
        ...    ((> 2 4) 6)
        ...    ((< 2 5) 7))
        ... ''')
        7
        >>> eval('''
        ... (cond ((> 2 3) 5)
        ...    ((> 2 4) 6)
        ...    (else 8))
        ... ''')
        8
        >>> eval('''
        ... (cond ((> 2 3) 4 5)
        ...    ((> 2 4) 5 6)
        ...    ((< 2 5) 6 7)
        ...    (else 7 8))
        ... ''')
        7
        >>> eval('''
        ... (cond ((> 2 3) (display 'oops) (newline))
        ...    (else 9))
        ... ''')
        9
        >>> eval('''
        ... (cond ((< 2 1))
        ...     ((> 3 2))
        ...     (else 5))
        ... ''')
        True
        >>> eval("(cond (#f 1))")
        okay
        """,
        'type': 'doctest'
      }
    ]
  ]
}